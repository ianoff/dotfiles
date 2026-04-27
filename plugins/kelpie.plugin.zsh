alias kelpie="cd ~/Dev/kelpie/"
alias cm="yarn commit"
export AWS_PROFILE=kelpie

# 1Password Environments (programmatic read via CLI):
# https://developer.1password.com/docs/environments/read-environment-variables/#cli
#
# Environment ID resolution (first match wins):
#   1. KELPIE_PROD_OP_ENVIRONMENT_ID — raw ID (optional ~/.zshenv override)
#   2. op read on KELPIE_PROD_OP_ENVIRONMENT_ID_REF (unset → op://Kelpie/Secrets/ProdEnvID)
#   3. OP_ENVIRONMENT_ID
# In ~/.zshenv: export KELPIE_PROD_OP_ENVIRONMENT_ID_REF= to skip (2); or set a different op://… ref.
#
# Requires beta-channel `op` with Environments (e.g. 2.35.x-beta): `op update --channel beta`
# and desktop app integration for local auth: https://developer.1password.com/docs/cli/get-started#step-2-turn-on-the-1password-desktop-app-integration
#
# If no ID is set, prod_* use PROD_DB_URL / PROD_DB_HOST from your shell (e.g. IDE / terminal sync).
#
# `op run --environment <uuid>` — override with KELPIE_OP_RUN_ENVIRONMENT_FLAG if needed.
: "${KELPIE_OP_RUN_ENVIRONMENT_FLAG:=--environment}"

typeset -g _kelpie_resolved_op_environment_id

function kelpie_op_environment_id() {
  local ref
  if [[ -n "${KELPIE_PROD_OP_ENVIRONMENT_ID:-}" ]]; then
    print -r -- "$KELPIE_PROD_OP_ENVIRONMENT_ID"
    return
  fi
  if [[ -n "${_kelpie_resolved_op_environment_id:-}" ]]; then
    print -r -- "$_kelpie_resolved_op_environment_id"
    return
  fi
  ref="${KELPIE_PROD_OP_ENVIRONMENT_ID_REF-op://Kelpie/Secrets/ProdEnvID}"
  if [[ -n "$ref" ]] && _kelpie_op_has_cli; then
    _kelpie_resolved_op_environment_id="$(op read "$ref" 2>/dev/null)"
    _kelpie_resolved_op_environment_id="${_kelpie_resolved_op_environment_id//$'\r'}"
    _kelpie_resolved_op_environment_id="${_kelpie_resolved_op_environment_id//$'\n'}"
  fi
  if [[ -n "${_kelpie_resolved_op_environment_id:-}" ]]; then
    print -r -- "$_kelpie_resolved_op_environment_id"
    return
  fi
  print -r -- "${OP_ENVIRONMENT_ID:-}"
}

function _kelpie_op_has_cli() {
  command -v op >/dev/null
}

# Run a command with Kelpie's 1Password Environment variables injected (op run --environment …).
# Pass the real argv only (e.g. sh -c '…'); do not prefix with -- (this wrapper adds op run's --).
function kelpie_with_op_environment() {
  local id
  id=$(kelpie_op_environment_id)
  if [[ -z "$id" ]]; then
    echo "kelpie: set KELPIE_PROD_OP_ENVIRONMENT_ID, op read via KELPIE_PROD_OP_ENVIRONMENT_ID_REF, or OP_ENVIRONMENT_ID" >&2
    return 1
  fi
  if ! _kelpie_op_has_cli; then
    echo "kelpie: op (1Password CLI) not found in PATH" >&2
    return 1
  fi
  op run "$KELPIE_OP_RUN_ENVIRONMENT_FLAG" "$id" -- "$@"
}

# Print variables from the Environment (key=value; masked per op defaults).
function kelpie_op_environment_read() {
  local id
  id=$(kelpie_op_environment_id)
  if [[ -z "$id" ]]; then
    echo "kelpie: set KELPIE_PROD_OP_ENVIRONMENT_ID, op read via KELPIE_PROD_OP_ENVIRONMENT_ID_REF, or OP_ENVIRONMENT_ID" >&2
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
  if [[ -n "$id" ]] && _kelpie_op_has_cli; then
    kelpie_with_op_environment sh -c 'ssh -i "$HOME/.ssh/kelpie-bastion.pem" -N -L "5444:${PROD_DB_HOST}:5432" ec2-user@52.35.75.115'
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
  if [[ -n "$id" ]] && _kelpie_op_has_cli; then
    kelpie_with_op_environment sh -c 'yarn prisma studio --url="$PROD_DB_URL"'
  else
    yarn prisma studio --url="$PROD_DB_URL"
  fi
}

function prod_psql {
  local id
  id=$(kelpie_op_environment_id)
  if [[ -n "$id" ]] && _kelpie_op_has_cli; then
    kelpie_with_op_environment sh -c 'psql "$PROD_DB_URL"'
  else
    psql "$PROD_DB_URL"
  fi
}