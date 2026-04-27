alias kelpie="cd ~/Dev/kelpie/"
alias cm="yarn commit"
export AWS_PROFILE=kelpie

# 1Password Environments (programmatic read via CLI):
# https://developer.1password.com/docs/environments/read-environment-variables/#cli
#
# Set KELPIE_OP_ENVIRONMENT_ID (preferred) or OP_ENVIRONMENT_ID to your Environment ID:
# 1Password app → Developer → View Environments → View environment → Manage environment → Copy environment ID.
#
# Requires beta-channel `op` with Environments (e.g. 2.35.x-beta): `op update --channel beta`
# and desktop app integration for local auth: https://developer.1password.com/docs/cli/get-started#step-2-turn-on-the-1password-desktop-app-integration
#
# If no ID is set, prod_* use PROD_DB_URL / PROD_DB_HOST from your shell (e.g. IDE / terminal sync).

function kelpie_op_environment_id() {
  print -r -- "${KELPIE_OP_ENVIRONMENT_ID:-$OP_ENVIRONMENT_ID}"
}

# `op run` may expose --environments (2.35+ docs) or --environment (older betas); support both.
function _kelpie_op_environment_run_supported() {
  command -v op >/dev/null || return 1
  op run --help 2>&1 | command grep -qF -- '--environments' && return 0
  op run --help 2>&1 | command grep -qE '[[:space:]]--environment([[:space:]=]|$)' && return 0
  return 1
}

function _kelpie_op_run_environment_argv() {
  local id="$1"
  if op run --help 2>&1 | command grep -qF -- '--environments'; then
    print -r -- --environments "$id"
  else
    print -r -- --environment "$id"
  fi
}

# Run a command with Kelpie's 1Password Environment variables injected (op run --environment[s]).
function kelpie_with_op_environment() {
  local id argv
  id=$(kelpie_op_environment_id)
  if [[ -z "$id" ]]; then
    echo "kelpie: set KELPIE_OP_ENVIRONMENT_ID or OP_ENVIRONMENT_ID" >&2
    return 1
  fi
  if ! _kelpie_op_environment_run_supported; then
    echo "kelpie: this op build has no Environment support on op run. Install beta (2.35+): op update --channel beta" >&2
    echo "kelpie: https://developer.1password.com/docs/environments/read-environment-variables/#cli" >&2
    return 1
  fi
  argv=("${(@f)$(_kelpie_op_run_environment_argv "$id")}")
  op run "${argv[@]}" -- "$@"
}

# Print variables from the Environment (key=value; masked per op defaults).
function kelpie_op_environment_read() {
  local id
  id=$(kelpie_op_environment_id)
  if [[ -z "$id" ]]; then
    echo "kelpie: set KELPIE_OP_ENVIRONMENT_ID or OP_ENVIRONMENT_ID" >&2
    return 1
  fi
  op environment read "$id"
}

function prod_shell {
  local CLUSTER="${1:-production}"
  local CONTAINER="${2:-api}"
  local REGION="${AWS_REGION:-us-west-2}"

  # get first running task in the cluster
  local TASK_ARN
  TASK_ARN=$(aws ecs list-tasks --cluster "$CLUSTER" --region "$REGION" --desired-status RUNNING \
            | jq -r '.taskArns[0]')

  if [[ -z "$TASK_ARN" || "$TASK_ARN" == "null" ]]; then
    echo "🚨 No running tasks found in cluster '$CLUSTER' (region $REGION)"
    return 1
  fi

  # optionally convert to task ID instead of full ARN:
  local TASK_ID="${TASK_ARN##*/}"

  echo "--> Connecting to task: $TASK_ID (cluster: $CLUSTER, container: $CONTAINER)"

  aws ecs execute-command \
    --cluster "$CLUSTER" \
    --region "$REGION" \
    --task "$TASK_ID" \
    --container "$CONTAINER" \
    --interactive \
    --command "/bin/bash"
}

export PATH="$PATH":"$HOME/.maestro/bin"

function prod_db {
  local id
  id=$(kelpie_op_environment_id)
  if [[ -n "$id" ]] && _kelpie_op_environment_run_supported; then
    kelpie_with_op_environment -- sh -c 'ssh -i "$HOME/.ssh/kelpie-bastion.pem" -N -L "5444:${PROD_DB_HOST}:5432" ec2-user@52.35.75.115'
  else
    ssh -i ~/.ssh/kelpie-bastion.pem \
      -N \
      -L "5444:${PROD_DB_HOST}:5432" \
      ec2-user@52.35.75.115
  fi
}

function prod_prisma {
  local id
  id=$(kelpie_op_environment_id)
  if [[ -n "$id" ]] && _kelpie_op_environment_run_supported; then
    kelpie_with_op_environment -- sh -c 'yarn prisma studio --url="$PROD_DB_URL"'
  else
    yarn prisma studio --url="$PROD_DB_URL"
  fi
}

function prod_psql {
  local id
  id=$(kelpie_op_environment_id)
  if [[ -n "$id" ]] && _kelpie_op_environment_run_supported; then
    kelpie_with_op_environment -- sh -c 'psql "$PROD_DB_URL"'
  else
    psql "$PROD_DB_URL"
  fi
}