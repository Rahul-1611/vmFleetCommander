#!/bin/bash

# Script to delete a resource group and everything in it

read -p "Name the Resource group to be deleted: " RG_NAME

read -p "Are you sure you want to delete '$RG_NAME'? This will delete ALL resources inside it. (y/N): " CONFIRM
if [[ "$CONFIRM" =~ ^[Yy]$ ]]; 
then 
    echo "Deleting resource group '$RG_NAME'..."
    az group delete --name "$RG_NAME" --yes
    echo "Done: RG has been Deleted"
else
    echo "Deletion canceled"
fi