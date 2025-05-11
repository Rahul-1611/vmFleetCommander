// Parameters
param vmName string // Name of the virtual machine
param vmSize string // Size/sku of the VM (e.g., Standard_B1s)

param location string // Azure region for deployment

param userName string = 'rdeshmu' // Admin username for the VM (default: rdeshmu)
@secure()
param adminPass string // Admin password for the VM

param subnetId string // Resource ID of the subnet to attach the NIC

param nicName string // Name of the Network Interface (NIC) to create

param ubuntuOSVersion string = 'Ubuntu-2004' // OS version to install on VM

// OS image reference map for different Ubuntu versions
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

// Create a network interface with dynamic private IP and connect it to the subnet
resource nic 'Microsoft.Network/networkInterfaces@2024-05-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'nicIPconfig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnetId // Use subnet ID passed from main module
          }
        }
      }
    ]
  }
}

// Deploy the virtual machine and attach the NIC created above
resource virtualMachine 'Microsoft.Compute/virtualMachines@2024-11-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize // VM SKU (e.g., Standard_B1s)
    }
    osProfile: {
      computerName: vmName // Internal computer name
      adminPassword: adminPass // Admin password (secure)
      adminUsername: userName // Admin username (default: rdeshmu)
    }
    storageProfile: {
      imageReference: imageReference[ubuntuOSVersion] // Select image based on version param
      osDisk: {
        deleteOption: 'Delete' // Delete OS disk when VM is deleted
        createOption: 'FromImage' // Create OS disk from selected image
        managedDisk: {
          storageAccountType: 'Standard_LRS' // Basic HDD storage
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id // Attach NIC to VM
          properties: {
            deleteOption: 'Delete' // Delete NIC when VM is deleted
          }
        }
      ]
    }
  }
}

// Output the resource ID of the virtual machine
output vmID string = virtualMachine.id
