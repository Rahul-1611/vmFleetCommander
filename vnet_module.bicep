// Parameters
param vnetName string // Name of the Virtual Network
param location string // Azure region for deployment

param subnetName string = 'subnet_1' // Name of the subnet (default: 'subnet_1')
param vnetAddressSpace array // Address space for the VNet (e.g., ['10.0.0.0/16'])
param subnetAddressSpace string // Address prefix for the subnet (e.g., '10.0.0.0/24')

// Create a Network Security Group (NSG) with no custom rules
resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: 'nsg-${subnetName}' // NSG named after the subnet
  location: location
  properties: {} // Empty ruleset (can be extended)
}

// Create the Virtual Network with one subnet
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: vnetAddressSpace // Apply the VNet address space (e.g., 10.0.0.0/16)
    }
  }

  // Define the first (and only) subnet inside the VNet
  resource subnet1 'subnets' = {
    name: subnetName
    properties: {
      addressPrefix: subnetAddressSpace // Subnet address range (e.g., 10.0.0.0/24)
      networkSecurityGroup: {
        id: networkSecurityGroup.id // Attach the previously created NSG
      }
    }
  }
}

// Output the subnet resource ID for downstream usage (e.g., VM NICs)
output subnet1ResourceId string = virtualNetwork::subnet1.id
