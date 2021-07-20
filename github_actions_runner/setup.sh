#!/usr/bin/env bash

. ./.env

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

export DEBIAN_FRONTEND=noninteractive

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
apt update
apt install yarn jq -y

# playwrigth dependencies
apt install -y \
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

./bin/installdependencies.sh

RUNNER_TOKEN_URI="https://api.github.com/repos/${ORGANIZATION}/${REPOSITORY_NAME}/actions/runners/registration-token"
export REPOSITORY_URI="https://github.com/${ORGANIZATION}/${REPOSITORY_NAME}"
export RUNNER_TOKEN=$(curl -X POST -H "Authorization: token ${GITHUB_TOKEN}" "${RUNNER_TOKEN_URI}" | jq -r .token)

su -m vagrant -c './config.sh --url "${REPOSITORY_URI}" --token "${RUNNER_TOKEN}" --name $(hostname)-$(openssl rand -hex 5) --unattended'

./svc.sh install
./svc.sh start
