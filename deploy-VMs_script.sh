#!/bin/bash

# ==== CONFIGURATION ====
RESOURCE_GROUP="vmFleetCommander"
LOCATION="westus"
BICEP_FILE="main.bicep"
PARAMETER_FILE="test.parameters.json"
# .bicepparam file input is not supported in az CLI (only Bicep CLI)

# ==== PARAMETERS ====
ADMIN_PASSWORD="<yourSecurePassword>" # Or use read -s to securely prompt
read -s -p "Enter admin password: " ADMIN_PASSWORD
echo 


# ==== LOGIN (Optional if already logged in) ====
# az login

# ==== CREATE RESOURCE GROUP (idempotent) ====
az group create \
  --name $RESOURCE_GROUP \
  --location $LOCATION

# # === VALIDATE BICEP AND PARAM FILES ===
# az deployment group validate \
#   --resource-group "$RESOURCE_GROUP" \
#   --template-file main.bicep \
#   --parameters @"$PARAMETER_FILE" adminPassword="$ADMIN_PASSWORD"


echo "Validated the files"

==== DEPLOY BICEP FILE ====
az deployment group create \
  --resource-group $RESOURCE_GROUP \
  --template-file $BICEP_FILE \
  --parameters @"$PARAMETER_FILE" \
    adminPassword=$ADMIN_PASSWORD

# ==== DONE ====
echo "✅ Deployment complete"
