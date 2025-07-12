#!/bin/bash
KEYVAULT_NAME="pgdtekv"
KEY_NAME="pg-dte-key"

NEW_KEY=$(openssl rand -base64 32)

az keyvault secret set   --vault-name "$KEYVAULT_NAME"   --name "$KEY_NAME"   --value "$NEW_KEY"

echo "New key uploaded to Azure Key Vault"