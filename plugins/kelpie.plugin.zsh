alias kelpie="cd ~/Dev/kelpie/"
alias cm="yarn commit"
export AWS_PROFILE=kelpie

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
export JAVA_HOME="$(
  /usr/libexec/java_home -v 17 2>/dev/null || echo "/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home"
)"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools"

# Normal 1Password values (resolved by op run)
export ENV_ID="op://Kelpie/Secrets/ProdEnvID"
export LOCAL_PORT="op://Kelpie/BastionHostSSHConfig/localDBPort"
export REMOTE_PORT="op://Kelpie/BastionHostSSHConfig/remotePort"
export EC2_USER="op://Kelpie/BastionHostSSHConfig/user"
export ECS_HOSTNAME="op://Kelpie/BastionHostSSHConfig/hostname"
export IDENTITY_FILE="op://Kelpie/BastionHostSSHConfig/identityfile"
export DB_NAME="op://Kelpie/BastionHostSSHConfig/dbname"

function prod_ssh {
  local RESOLVED_ENV_ID
  RESOLVED_ENV_ID="$(op read "$ENV_ID")" || return 1
  op run --environment "$RESOLVED_ENV_ID" -- zsh -c 'ssh -i "$IDENTITY_FILE" -N -L "${LOCAL_PORT}:${DB_HOST}:${REMOTE_PORT}" "${EC2_USER}@${ECS_HOSTNAME}"'
}

function prod_prisma {
  local RESOLVED_ENV_ID
  RESOLVED_ENV_ID="$(op read "$ENV_ID")" || return 1
  op run --environment "$RESOLVED_ENV_ID" -- zsh -c 'yarn prisma studio --url="postgresql://${DB_USER}:${DB_PASSWORD}@127.0.0.1:${LOCAL_PORT}/${DB_NAME}?sslmode=require"'
}