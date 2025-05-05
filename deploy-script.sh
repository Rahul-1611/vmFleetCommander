#!/bin/bash

# ==== CONFIGURATION ====
RESOURCE_GROUP="vmFleetCom"
LOCATION="eastus"
BICEP_FILE="main.bicep"

# ==== PARAMETERS ====
ADMIN_PASSWORD="<yourSecurePassword>" # Or use read -s to securely prompt

# ==== LOGIN (Optional if already logged in) ====
# az login

# ==== CREATE RESOURCE GROUP (idempotent) ====
az group create \
  --name $RESOURCE_GROUP \
  --location $LOCATION

# ==== DEPLOY BICEP FILE ====
az deployment group create \
  --resource-group $RESOURCE_GROUP \
  --template-file $BICEP_FILE \
  --parameters \
    adminPassword=$ADMIN_PASSWORD

# ==== DONE ====
echo "✅ Deployment complete"
