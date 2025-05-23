#!/bin/bash
# Script to deploy a resource group 
deploymentName="demoSubDeployment"
deploymentLocation="westus"
templateFile="./createRG.bicep"

echo "Starting deployment: $deploymentName..."

az deployment sub create \
  --name "$deploymentName" \
  --location "$deploymentLocation" \
  --template-file "$templateFile"

echo "✅ Resource group deployment complete."