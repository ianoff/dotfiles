alias kelpie="cd ~/Dev/kelpie/"
alias cm="yarn commit"
export AWS_PROFILE=kelpie
export SCHEDULE_RECONCILE_SECRET=97fb0cab1547297491864ddb3e2e1e821a7ff129c6b6ddd45a980e99bbb53036

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
export PROD_DB_URL="postgresql://kelpie:D4xoGQ3eDhvWksneA@kelpie-production.ch0iqwssco35.us-west-2.rds.amazonaws.com:5432/kelpie?sslmode=require"

export PROD_DB_HOST="kelpie-production.ch0iqwssco35.us-west-2.rds.amazonaws.com"

function prod_db {
  ssh -i ~/.ssh/kelpie-bastion.pem \
  -N \
  -L 5444:$PROD_DB_HOST:5432 \
  ec2-user@52.35.75.115
}

function prod_prisma {
  yarn prisma studio --url="$PROD_DB_URL"
}

function prod_psql {
  psql "$PROD_DB_URL"
}