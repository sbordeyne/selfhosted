#!/usr/bin/env bash

# This script is used to apply a patch to a Scylla cluster.

TMPDIR="/tmp/vault"
mkdir -p $TMPDIR
trap "rm -rf $TMPDIR" EXIT  # Remove the private key file when the script exits

set -euo pipefail

# Function to display script usage
function display_usage() {
  echo "Usage: $0 -p <path> -k <secret_key1> <secret_key2>..."
  echo "Options:"
  column -t -s ":" <<EOF
  -p:PATH:Secret path in Vault. The secret will be stored at secrets/<path>.
  -k:KEY:Secret keys to store at the specified path. Multiple keys can be provided as space-separated values.
EOF
  exit 1
}

test $# -eq 0 && display_usage && exit 1

# Parse command line arguments
while getopts ":p:d:" opt; do
    case $opt in
        p) SECRET_PATH="$OPTARG";;
        d) IFS=' ' read -ra DATA <<< "$OPTARG";;
        \?) echo "Invalid option: -$OPTARG" >&2; display_usage;;
        :) echo "Option -$OPTARG requires an argument." >&2; display_usage;;
    esac
done

# Check if SECRET_PATH is set
if [ -z "${SECRET_PATH:-}" ]; then
  echo "Error: Secret path is required."
  display_usage
fi

# Check if DATA is set
if [ -z "${DATA:-}" ]; then
  echo "Error: Secret data is required."
  display_usage
fi

# For each key in DATA, create a key-value pair by asking the user for input (hidden input)
SECRET_DATA=""
for KEY in "${DATA[@]}"; do
  read -s -p "Enter value for $KEY: " VALUE
  echo
  # Append the key-value pair to SECRET_DATA
  SECRET_DATA="$SECRET_DATA $KEY=\"$VALUE\""
done

# Needs unsealing first, but that's outside the scope of this script
# Store the secret in Vault at the specified path
vault kv put secrets/$SECRET_PATH $SECRET_DATA

# Create the policies to access the secret

POLICY_BASE_NAME=$(sed 's/\//-/g' <<< "$SECRET_PATH")
vault policy write "${POLICY_BASE_NAME}-reader" - <<EOF
path "secrets/${SECRET_PATH}" {
  capabilities = ["read", "list"]
}
EOF
vault policy write "${POLICY_BASE_NAME}-writer" - <<EOF
path "secrets/${SECRET_PATH}" {
  capabilities = ["create", "update"]
}
EOF
vault policy write "${POLICY_BASE_NAME}-admin" - <<EOF
path "secrets/${SECRET_PATH}" {
  capabilities = ["read", "create", "update", "delete", "list"]
}
EOF
