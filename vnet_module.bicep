param vnetName string
param location string

param subnetName string = 'subnet_1'
param vnetAddressSpace array
param subnetAddressSpace string

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: 'nsg-${subnetName}'
  location: location
  properties: {}
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: vnetAddressSpace
    }
  }
  resource subnet1 'subnets' = {
    name: subnetName
    properties: {
      addressPrefix: subnetAddressSpace
      networkSecurityGroup: {
        id: networkSecurityGroup.id
      }
    }
  }
}

output subnet1ResourceId string = virtualNetwork::subnet1.id
