param projectName string = 'vmFleet'
param location string = 'westus'
param instanceCount int = 3

@description('Test is for trial , final is for final code')
@allowed(['test', 'final'])
param env string = 'test'

var vmName = '${projectName}-${env}-vm'
var vnetName = '${projectName}-${env}-vnet'
var nicName = '${projectName}-${env}-nic'
