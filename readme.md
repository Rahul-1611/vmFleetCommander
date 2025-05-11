# 🚀 vmFleetCommander

**vmFleetCommander** is an Infrastructure-as-Code (IaC) project using Bicep to provision Azure infrastructure. It supports multi-VM fleet deployments with reusable modules for VNet, NSG, and VM creation, as well as scripts and parameter files for automation and testing.

---
## 📝 Prerequisites

- Azure CLI installed and logged in (`az login`)
- Bicep CLI installed (or use Azure CLI 2.20+ which includes it)
- An existing Azure subscription

## 📁 Project Structure

```plaintext
.
├── createRG.bicep               # Subscription-level resource group creation
├── createRG.json                # JSON equivalent of createRG.bicep (for reference or conversion)
├── delete-RG.sh                 # Bash script to delete a resource group interactively
├── deploy-RG_script.sh          # Bash script to deploy resource group
├── deploy-VMs_script.sh         # Bash script to deploy main Bicep file
├── final.parameters.json        # Parameter file for production/final deployment
├── main.bicep                   # Main entry: deploys VNet + N VMs using modules
├── readme.md                    # Project documentation (this file)
├── singleLinuxVM.bicep          # Minimal Bicep template for a standalone VM (demo/test)
├── singleLinuxVM.json           # ARM JSON version of the single VM template
├── test.bicepparam              # Bicep-native parameter file for test config
├── test.parameters.json         # JSON parameter file for test config
├── vm_Module.bicep              # VM deployment module (VM + NIC)
├── vnet_module.bicep            # VNet + Subnet + NSG deployment module
```

## 📂 Module Overview

### `main.bicep`
- Coordinates the full stack deployment.
- Uses `vnet_module.bicep` and `vm_Module.bicep`.
- Supports dynamic VM instance count via loop.

### `vnet_module.bicep`
- Creates a Virtual Network with the specified address space.
- Adds a subnet and attaches a Network Security Group (NSG) with no default rules.

### `vm_Module.bicep`
- Creates a Linux VM using a selected Ubuntu image.
- Attaches a dynamically created NIC and outputs the VM’s resource ID.

### `singleLinuxVM.bicep`
- Standalone template to deploy a single Linux VM.
- Useful for quick tests or minimal deployments.


## 🖥️ VM Configuration 

The templates deploy Linux virtual machine with the following default configuration:

- **Size**: Standard_B1s (1 vCPU, 1GB RAM) - Cost-effective for lightweight workloads, Free Tier
- **OS**: Ubuntu Server 22.04 LTS (Canonical)
- **Networking**: 
  - Virtual Network with address space 192.168.0.0/16
  - Subnet with address space 192.168.0.0/24
  - Dynamic private IP allocation
  - Network Interface with default configuration
- **Storage**: Standard HDD managed disk (Standard_LRS)
- **Computer Name**: TestVM (customizable)
- **Admin Username**: **** (customizable)
- **Security**: Password authentication (secure parameter)


## 🚀 Deployment Options

### ✅ Option 1: Use the Bash Script (Optional)

A helper script is included:

```bash
chmod +x deploy-VMs_script.sh
./deploy-VMs_script.sh
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
  --resource-group vmFleetCommander \
  --template-file main.bicep \
  --parameters @test.parameters.json adminPassword=$ADMIN_PASSWORD
```

## 🧹 Deletion (Teardown)

To delete the entire resource group interactively:

```bash
chmod +x delete-RG.sh
./delete-RG.sh
```
## References

📄 **Microsoft Documentation:**
* [Quick-create a Linux VM with Bicep (Microsoft Learn)](https://learn.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-bicep?tabs=CLI)

🤖 **Assistance & Authoring Support:**

ChatGPT-4o

---

## 🧠 Project Inspiration

This project was inspired by the excellent open-source work at:

🔗 [cloud-engineering-projects by @madebygps](https://github.com/madebygps/cloud-engineering-projects)

Credit for the original project idea structure and learning goals goes to them.
