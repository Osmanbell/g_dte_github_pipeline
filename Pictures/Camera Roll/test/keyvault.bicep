@description('Specifies the location for resources.')
param location string 
param keyvaultName string 

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: keyvaultName
  location: location
  properties: {
    sku: {
      name: 'standard'
      family: 'A'
    }
    accessPolicies: [ ]
    tenantId: subscription().tenantId
  }
}
