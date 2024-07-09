@description('Specifies the location for resources.')
param location string
@secure()
param mysqlServerAdministratorLogin string 
@secure()
param mysqlServerAdministratorPassword string 
param databaseName string
param mysqlserverName string
param mysqlsubnetId string
param mysqlVersion string 
param skuName string 
param SkuTier string 
param storageSizeGB int 
param storageIops int 
param storageAutogrow string
param backupRetentionDays int 
param geoRedundantBackup string 
// param firewallRules array 

resource mySQLServer 'Microsoft.DBforMySQL/flexibleServers@2021-12-01-preview' = {
  name: mysqlserverName
  location: location
  sku: {
    name: skuName
    tier: SkuTier
  }
  // identity: {
  //   type: 'UserAssigned'
  //   userAssignedIdentities: {
  //   }
  // }
  properties: {
    administratorLogin: mysqlServerAdministratorLogin
    administratorLoginPassword: mysqlServerAdministratorPassword
    version: mysqlVersion
    highAvailability: {
      mode: 'ZoneRedundant'
    }
    storage: {
      storageSizeGB: storageSizeGB
      iops: storageIops
      autoGrow: storageAutogrow
    }
    network: {
      delegatedSubnetResourceId: mysqlsubnetId
    }
    backup: {
      backupRetentionDays: backupRetentionDays
      geoRedundantBackup: geoRedundantBackup
    }
  }
}
resource mySQLDatabase 'Microsoft.DBforMySQL/flexibleServers/databases@2021-12-01-preview' = {
  name: databaseName
  parent: mySQLServer
  properties: {
    charset: 'utf8'
    collation: 'utf8_general_ci'
  }
}

// @batchSize(1)
// resource myfirewallRules 'Microsoft.DBforMySQL/flexibleServers/firewallRules@2021-12-01-preview' = [for ip in firewallRules: {
//   parent: mySQLServer
//   name: ip.name
//   properties: {
//     startIpAddress: ip.startIPAddress
//     endIpAddress: ip.endIPAddress
//   }
// }]

output mySQLServerId string = mySQLServer.id
output mySQLDatabaseId string = mySQLDatabase.id
