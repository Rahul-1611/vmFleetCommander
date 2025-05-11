// Orchestrates the deployment of a virtual network and multiple virtual machines based on environment-specific configurations. This is the main entry point of the `vmFleetCommander` infrastructure.

// ========== Parameters ==========

param projectName string = 'vmFleet' // Base name for all resources
param location string = 'westus' // Azure region for deployment
param vmSize string = 'Standard_B1s' // Size of each VM
param instanceCount int = 3 // Number of VMs to deploy

@secure()
param adminPassword string // Admin password for all VMs

@description('Test is for trial , final is for final code')
@allowed(['test', 'final'])
param env string = 'test' // Environment name (used in naming)

// ========== Derived Names ==========

var baseName = '${projectName}-${env}' // Common prefix for all resources
var vnetName = '${baseName}-vnet' // Name of the virtual network
var subnetName = '${projectName}-${env}-subnet' // Name of the subnet
// var subnetRef = vnet.properties.subnets[0].id // This extracts the id of the first subnet from the VNet resource 

// ========== Network Configuration ==========

param virtualNetAddPrefix array = ['10.0.0.0/16'] // Address space for the VNet
param subnetPrefix string = '10.0.0.0/24' // Address space for the subnet

// ========== VNet Module Deployment ==========

module vNetwork 'vnet_module.bicep' = {
  name: 'vNetDeployment'
  params: {
    vnetName: vnetName
    location: location
    vnetAddressSpace: virtualNetAddPrefix
    subnetName: subnetName
    subnetAddressSpace: subnetPrefix
  }
}

// Capture subnet ID from vNetwork module output
var subnetRef = vNetwork.outputs.subnet1ResourceId

// ========== VM Module Deployment Loop ==========

module vMachines 'vm_Module.bicep' = [
  for i in range(1, instanceCount): {
    // for <index> in range(<startIndex>, <numberOfElements>): 
    name: 'vmDeployment-${padLeft(string(i),2,'0')}' // Zero-padded VM deployment name
    params: {
      vmName: '${baseName}-vm${padLeft(string(i),2,'0')}' // VM name (e.g., vmFleet-test-vm01)
      nicName: '${baseName}-nic-${padLeft(string(i),2,'0')}' // NIC name (e.g., vmFleet-test-nic-01)
      location: location
      vmSize: vmSize
      adminPass: adminPassword
      subnetId: subnetRef
    }
  }
]

// ========== Output ==========

// Export the resource IDs of all created VMs
output vmIds array = [for i in range(0, instanceCount): vMachines[i].outputs.vmID]
