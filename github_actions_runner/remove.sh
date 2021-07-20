#!/usr/bin/env bash

. ./.env

if [[ ! -d "actions-runner" ]]; then
  echo "'actions-runner' dir missing; exiting";
  exit 1;
fi

for var in ORGANIZATION REPOSITORY_NAME GITHUB_TOKEN;
do
  [[ -z "${!var}" ]] && {
    >&2 echo "missing environment variable: $var";
    missing_var=1
  }
done

if [[ "${missing_var}" -eq 1 ]] ;then
  >&2 echo "exiting"
  exit 1
fi

RUNNER_TOKEN_URI="https://api.github.com/repos/${ORGANIZATION}/${REPOSITORY_NAME}/actions/runners/registration-token"

# runner token
export RUNNER_TOKEN=$(curl -X POST -H "Authorization: token ${GITHUB_TOKEN}" "${RUNNER_TOKEN_URI}" | jq -r .token)

# remove runner
cd actions-runner

./svc.sh uninstall

su -m vagrant -c './config.sh remove --token "${RUNNER_TOKEN}"'
