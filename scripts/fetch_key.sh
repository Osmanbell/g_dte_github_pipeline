#!/bin/bash
az keyvault secret download   --vault-name pgdtekv   --name pg-dte-key   --file ./env/encryption.key   --encoding base64