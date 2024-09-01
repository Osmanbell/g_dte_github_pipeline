param sqlservername string
param location string
param azuresqladminlogin string
@secure()
param azuresqladminpassword string
param sqlDBName string
param sqlsubnetId string

resource SQLServer 'Microsoft.Sql/servers@2023-05-01-preview' = {
  name: sqlservername
  location: location
  properties: {
    administratorLogin: azuresqladminlogin
    administratorLoginPassword: azuresqladminpassword
  }
}

resource vnetRule 'Microsoft.Sql/servers/virtualNetworkRules@2023-05-01-preview' = {
  parent: SQLServer
  name: 'vnetRule'
  properties: {
    virtualNetworkSubnetId: sqlsubnetId
  }
}


resource sqlDatabase 'Microsoft.Sql/servers/databases@2023-05-01-preview' = {
  parent: SQLServer
  name: sqlDBName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
}

output SQLServerId string = SQLServer.id
output sqlDatabaseId string = sqlDatabase.id
