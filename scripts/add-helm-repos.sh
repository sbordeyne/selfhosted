#!/usr/bin/env bash

# Add all helm repositories in this repo to the local helm client
# Usage: add-helm-repos.sh
set -euo pipefail

# Go to the root of the repository
cd "$(dirname "$0")/.."
# Get all helm repositories from the flux source
HELMREPOS=$(ls clusters/kubernetes/helm-repositories/*.yaml)
if [ -z "$HELMREPOS" ]; then
  echo "No Helm repositories found."
  cd -
  exit 0
fi

# Add each helm repository to the local helm client
for REPO in $HELMREPOS; do
  NAME=$(yq -r '.metadata.name' "$REPO")
  URL=$(yq -r '.spec.url' "$REPO")
  if helm repo list | grep -q "$NAME"; then
    echo "Repository $NAME already exists, skipping."
  else
    echo "Adding Helm repository: $NAME ($URL)"
    helm repo add "$NAME" "$URL"
  fi
done

# Update the helm repositories
echo "Updating Helm repositories..."
helm repo update

# Go back to the original directory
cd -
echo "All Helm repositories added and updated successfully."
# End of script

# vim: set ts=2 sw=2 et:
