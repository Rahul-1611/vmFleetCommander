targetScope = 'subscription'

param rgName string = 'vmFleetDeployment'
param rgLocation string = 'westus'

resource resourceGrp 'Microsoft.Resources/resourceGroups@2025-03-01' = {
  name: rgName
  location: rgLocation
}
