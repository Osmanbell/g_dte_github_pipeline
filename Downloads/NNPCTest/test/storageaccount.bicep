@description('Specifies the location for resources.')
param location string
param storageaccName string 

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageaccName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

output storageAccountId string = storageAccount.id
