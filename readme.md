# Deploy a Linux Virtual Machine with Bicep

This project contains a simple Bicep template (`singleLinuxVM.bicep`) to deploy a minimal Linux virtual machine in Azure.

## 📝 Prerequisites

- Azure CLI installed and logged in (`az login`)
- Bicep CLI installed (or use Azure CLI 2.20+ which includes it)
- An existing Azure subscription
## 📋 Project Structure

- `main.bicep` - Main deployment template that orchestrates VM deployments
- `singleLinuxVM.bicep` - Template for deploying a single Linux VM
- `singleLinuxVM.json` - ARM template version (compiled from Bicep)
- `deploy-script.sh` - Helper script for deployments

## 🖥️ VM Configuration (For Single VM)

The templates deploy Linux virtual machine with the following default configuration:

- **VM Name**: myVM (customizable via parameters)
- **Size**: Standard_B1ls (1 vCPU, 0.5GB RAM) - Cost-effective for lightweight workloads
- **OS**: Ubuntu Server 22.04 LTS (Canonical)
- **Networking**: 
  - Virtual Network with address space 10.0.0.0/16
  - Subnet with address space 10.0.0.0/24
  - Dynamic private IP allocation
  - Network Interface with default configuration
- **Storage**: Standard HDD managed disk (Standard_LRS)
- **Computer Name**: TestVM (customizable)
- **Admin Username**: **** (customizable)
- **Security**: Password authentication (secure parameter)

All resource locations default to East US but can be customized during deployment.

## 🔐 Password Input

The VM admin password is defined as a secure parameter in the Bicep file.

You can hardcode it in the .sh file 

or

When deploying, you'll need to pass it securely:

```bash
read -s -p "Enter admin password: " ADMIN_PASSWORD
echo
az deployment group create \
  --resource-group <your-resource-group> \
  --template-file singleLinuxVM.bicep \
  --parameters adminPassword=$ADMIN_PASSWORD
```
## 🚀 Deployment Options

### ✅ Option 1: Use the Bash Script (Optional)

A helper script is included:

```bash
chmod +x deploy-script.sh
./deploy-script.sh
```
### ✅ Option 2: Use Azure CLI Directly

💡 Note: The bash script is not required — you can run everything manually in the terminal
```bash
# Create resource group if needed
az group create --name <your-resource-group> --location eastus

# Securely input password
read -s -p "Enter admin password: " ADMIN_PASSWORD
echo

# Deploy using the Bicep file directly
az deployment group create \
  --resource-group <your-resource-group> \
  --template-file singleLinuxVM.bicep \
  --parameters adminPassword=$ADMIN_PASSWORD
```
## References

📄 **Microsoft Documentation:**
* [Quick-create a Linux VM with Bicep (Microsoft Learn)](https://learn.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-bicep?tabs=CLI)

🤖 **Assistance & Authoring Support:**

ChatGPT-4o