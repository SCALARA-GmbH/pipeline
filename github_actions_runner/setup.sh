#!/usr/bin/env bash

. ./.env

for var in ORGANIZATION REPOSITORY_NAME GITHUB_TOKEN RUNNER_LABELS;
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

export DEBIAN_FRONTEND=noninteractive

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update
sudo apt install yarn jq -y

# playwrigth dependencies
sudo apt install -y \
  libgbm1 \
  libnss3 \
  libxss1 \
  libasound2 \
  libdbus-glib-1-2 \
  xvfb \
  gconf-service \
  libatk1.0-0 \
  libc6 \
  libcairo2 \
  libcups2 \
  libdbus-1-3 \
  libexpat1 \
  libfontconfig1 \
  libgcc1 \
  libgconf-2-4 \
  libgdk-pixbuf2.0-0 \
  libglib2.0-0 \
  libgtk-3-0 \
  libnspr4 \
  libpango-1.0-0 \
  libpangocairo-1.0-0 \
  libstdc++6 \
  libx11-6 \
  libx11-xcb1 \
  libxcb1 \
  libxcomposite1 \
  libxcursor1 \
  libxdamage1 \
  libxext6 \
  libxfixes3 \
  libxi6 \
  libxrandr2 \
  libxrender1 \
  libxss1 \
  libxtst6 \
  ca-certificates \
  fonts-liberation \
  libappindicator1 \
  libnss3 \
  lsb-release \
  xdg-utils

cd actions-runner

curl -o actions-runner-linux-x64-2.278.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.278.0/actions-runner-linux-x64-2.278.0.tar.gz
tar xzf ./actions-runner-linux-x64-2.278.0.tar.gz

sudo ./bin/installdependencies.sh

RUNNER_TOKEN_URI="https://api.github.com/repos/${ORGANIZATION}/${REPOSITORY_NAME}/actions/runners/registration-token"
REPOSITORY_URI="https://github.com/${ORGANIZATION}/${REPOSITORY_NAME}"
RUNNER_TOKEN=$(curl -X POST -H "Authorization: token ${GITHUB_TOKEN}" "${RUNNER_TOKEN_URI}" | jq -r .token)

./config.sh --url "${REPOSITORY_URI}" --token "${RUNNER_TOKEN}" --name $(hostname)-$(openssl rand -hex 5) --unattended --labels "${RUNNER_LABELS}"

sudo ./svc.sh install
sudo ./svc.sh start

