// Creates a resource group at the subscription level. 

targetScope = 'subscription'

param rgName string = 'vmFleetCommander'
param rgLocation string = 'westus'

resource resourceGrp 'Microsoft.Resources/resourceGroups@2025-03-01' = {
  name: rgName
  location: rgLocation
}
