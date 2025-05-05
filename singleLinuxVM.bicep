param virtualMachineName string = 'myVM'
param virtualMachineSize string = 'Standard_B1ls'
param virtualMachineComputerName string = 'TestVM'
param adminUsername string = 'rdeshmu'

param virtualNetAddPrefix array = ['10.0.0.0/16']
param subnetName string = 'subnet1'
var subnetPrefix = '10.0.0.0/24'
// gives '10.0.0.0/24'
param ubuntuOSVersion string = 'Ubuntu-2004'
var subnetRef = '${virtualNetwork.id}/subnets/${subnetName}'

var imageReference = {
  'Ubuntu-2004': {
    publisher: 'Canonical'
    offer: '0001-com-ubuntu-server-focal'
    sku: '20_04-lts-gen2'
    version: 'latest'
  }
  'Ubuntu-2204': {
    publisher: 'Canonical'
    offer: '0001-com-ubuntu-server-jammy'
    sku: '22_04-lts-gen2'
    version: 'latest'
  }
}

param location string = 'eastus'

@secure()
param adminPassword string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: 'myVnet'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: virtualNetAddPrefix
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefix
        }
      }
    ]
  }
}
resource nic 'Microsoft.Network/networkInterfaces@2024-05-01' = {
  name: 'myNIC'
  location: resourceGroup().location
  properties: {
    ipConfigurations: [
      {
        name: 'ipNicConfig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnetRef
          }
        }
      }
    ]
  }
}

resource virtualMachine 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: virtualMachineName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: virtualMachineSize
    }
    osProfile: {
      computerName: virtualMachineComputerName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: imageReference[ubuntuOSVersion]

      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
  }
}
