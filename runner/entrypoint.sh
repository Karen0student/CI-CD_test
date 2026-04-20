#!/bin/bash
set -e

echo "Starting runner: $RUNNER_NAME"

# ./run.sh --version
# #confirmation of repo access
# curl -H "Authorization: Bearer $GITHUB_PAT" "https://api.github.com/repos/$OWNER/$REPO"

# # check auth (optional)
# curl -s -X POST \
#   -H "Authorization: Bearer $GITHUB_PAT" \
#   -H "Accept: application/vnd.github+json" \
#   https://api.github.com/repos/$OWNER/$REPO/actions/runners/registration-token

# get registration token
TOKEN=$(curl -s -X POST \
  -H "Authorization: Bearer $GITHUB_PAT" \
  -H "Accept: application/vnd.github+json" \
  https://api.github.com/repos/$OWNER/$REPO/actions/runners/registration-token \
  | jq -r .token)

if [ -z "$TOKEN" ] || [ "$TOKEN" = "null" ]; then
  echo "Token fetch failed"
  exit 1
fi

echo $TOKEN

# configure runner
CUSTOM_WORKDIR="/home/runner/_work"
mkdir -p $CUSTOM_WORKDIR
./config.sh \
  --url https://github.com/$OWNER/$REPO \
  --token $TOKEN \
  --name $RUNNER_NAME \
  --work $CUSTOM_WORKDIR \
  --labels self-hosted,linux \
  --unattended \
  --replace

# cleanup on exit
cleanup() {
  echo "Removing runner..."
  ./config.sh remove --unattended --token $TOKEN
}
trap cleanup EXIT

# start runner
./run.sh