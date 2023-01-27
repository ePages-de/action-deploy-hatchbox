#!/bin/sh -l

echo "https://app.hatchbox.io/webhooks/deployments/$INPUT_DEPLOY_KEY?latest=true"

activity_id=$(curl -X POST https://app.hatchbox.io/webhooks/deployments/$INPUT_DEPLOY_KEY?latest=true | jq -r '.id')

if [ "$activity_id" = "null" ]; then
  echo "Deploy request failed"
  exit 1
else
  deploy_state=$(curl https://app.hatchbox.io/apps/$INPUT_DEPLOY_KEY/activities/$activity_id | jq -r '.state')

  while [ "$deploy_state" = "processing" ]
  do
    sleep 10

    deploy_state=$(curl https://app.hatchbox.io/apps/$INPUT_DEPLOY_KEY/activities/$activity_id | jq -r '.state')
  done

  if [ "$deploy_state" = "completed" ]; then
    echo "Deploy succeeded"
    exit 0
  else
    echo "Deploy failed"
    exit 1
  fi
fi
