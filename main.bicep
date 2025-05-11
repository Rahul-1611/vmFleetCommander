param projectName string = 'vmFleet'
param location string = 'westus'
param vmSize string = 'Standard_B1s'
param instanceCount int = 3

@secure()
param adminPassword string

@description('Test is for trial , final is for final code')
@allowed(['test', 'final'])
param env string = 'test'

var baseName = '${projectName}-${env}'
var vnetName = '${baseName}-vnet'

param virtualNetAddPrefix array = ['10.0.0.0/16']
param subnetPrefix string = '10.0.0.0/24'
var subnetName = '${projectName}-${env}-subnet'
// var subnetRef = vnet.properties.subnets[0].id // This extracts the id of the first subnet from the VNet resource 

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
var subnetRef = vNetwork.outputs.subnet1ResourceId

module vMachines 'vm_Module.bicep' = [
  for i in range(1, instanceCount): {
    // for <index> in range(<startIndex>, <numberOfElements>): 
    name: 'vmDeployment-0${i}'
    params: {
      vmName: '${baseName}-vm${padLeft(string(i),2,'0')}'
      nicName: '${baseName}-nic-${padLeft(string(i),2,'0')}'
      location: location
      vmSize: vmSize
      adminPass: adminPassword
      subnetId: subnetRef
    }
  }
]
output vmIds array = [for i in range(0, instanceCount): vMachines[i].outputs.vmID]
