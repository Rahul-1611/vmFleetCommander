using 'main.bicep'

// parameter file for main.bicep
param env = 'final'
//for final.bicepparam,change to final, since all the other params r same

param projectName = 'vmFleet'
param location = 'westus'
param vmSize = 'Standard_B1s'
param instanceCount = 3

param virtualNetAddPrefix = ['192.168.0.0/16']
param subnetPrefix = '192.168.0.0/24'

param adminPassword = '<noRealPassword>'
