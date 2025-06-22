#!/usr/bin/env bash

SECRET_PATH="$1"

if [ -z "$SECRET_PATH" ]; then
  echo "Error: Secret path is required."
  exit 1
fi

POLICY_BASE_NAME=$(sed 's/\//-/g' <<< "$SECRET_PATH")
echo "Creating policies for secret path: $SECRET_PATH"
echo "Policy base name: $POLICY_BASE_NAME"

echo "Creating reader policy: ${POLICY_BASE_NAME}-reader"
vault policy write "${POLICY_BASE_NAME}-reader" - <<EOF
path "secrets/data/${SECRET_PATH}" {
  capabilities = ["read", "list"]
}
EOF

echo "Creating writer policy: ${POLICY_BASE_NAME}-writer"
vault policy write "${POLICY_BASE_NAME}-writer" - <<EOF
path "secrets/data/${SECRET_PATH}" {
  capabilities = ["create", "update"]
}
EOF

echo "Creating admin policy: ${POLICY_BASE_NAME}-admin"
vault policy write "${POLICY_BASE_NAME}-admin" - <<EOF
path "secrets/data/${SECRET_PATH}" {
  capabilities = ["read", "create", "update", "delete", "list"]
}
EOF
