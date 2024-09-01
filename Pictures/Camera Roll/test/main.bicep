@description('Specifies the location for resources.')
param location string 

@description('Name of the virtual network.')
param myVirtualNetworkName string 

@description('Name of the subnet for MySQL Database.')
param subnetName string

@description('Name of the subnet for SQL Server.')
param subnet2Name string

@description('Name of the subnet for App Service.')
param subnet3Name string

@secure()
@description('Administrator login for MySQL server.')
param mysqlServerAdministratorLogin string

@secure()
@description('Administrator password for MySQL server.')
param mysqlServerAdministratorPassword string

@description('MySQL version.')
param mysqlVersion string 

@description('SKU name for MySQL server.')
param skuName string 

@description('SKU tier for MySQL server.')
param SkuTier string 

@description('Storage size in GB for MySQL server.')
param storageSizeGB int 

@description('Storage IOPS for MySQL server.')
param storageIops int 

@description('Storage auto-grow setting for MySQL server.')
param storageAutogrow string

@description('Backup retention days for MySQL server.')
param backupRetentionDays int 

@description('Geo-redundant backup setting for MySQL server.')
param geoRedundantBackup string

@description('Name of the Key Vault.')
param keyvaultName string 

@description('Name of the MySQL server.')
param mysqlserverName string

@description('Name of the MySQL database.')
param databaseName string

@secure()
@description('Administrator login for SQL server.')
param azuresqladminlogin string

@secure()
@description('Administrator password for SQL server.')
param azuresqladminpassword string

@description('Name of the SQL database.')
param sqlDBName string

@description('Name of the SQL server.')
param sqlservername string

@description('Name of the App Service.')
param appServiceName string

@description('Name of the App Service slot.')
param appNameslot array = ['slot1', 'slot2']

@description('Name of the Front Door profile.')
param frontDoorProfileName string

@description('SKU name for the Front Door.')
param frontDoorSkuName string

@description('Name of the Front Door origin group.')
param frontDoorOriginGroupName string

@description('Name of the Front Door origin.')
param frontDoorOriginName string

@description('Name of the Front Door route.')
param frontDoorRouteName string

@description('Name of the Storage Account.')
param storageaccName string

module vnet 'virtualnetwork.bicep' = {
  name: myVirtualNetworkName
  params: {
    myVirtualNetworkName: myVirtualNetworkName
    subnetName: subnetName
    subnet2Name: subnet2Name
    subnet3Name: subnet3Name
  }
}

// Deploy MySQL server
module mySQLServer 'mysql.bicep' = {
  name: mysqlserverName
  dependsOn: [
    vnet
  ]
  params: {
    location: location
    mysqlserverName: mysqlserverName
    databaseName: databaseName
    mysqlServerAdministratorLogin: mysqlServerAdministratorLogin
    mysqlServerAdministratorPassword: mysqlServerAdministratorPassword
    mysqlsubnetId: vnet.outputs.mysqlSubnetId
    backupRetentionDays: backupRetentionDays
    geoRedundantBackup: geoRedundantBackup
    mysqlVersion: mysqlVersion
    SkuName: skuName
    SkuTier: SkuTier
    storageAutogrow: storageAutogrow
    storageIops: storageIops
    storageSizeGB: storageSizeGB
  }
}

// Deploy Key Vault
module keyvault 'keyvault.bicep' = {
  name: keyvaultName
  dependsOn: [
    vnet
  ]
  params: {
    keyvaultName: keyvaultName
    location: location
  }
}

// Deploy SQL Server and Database
module SQLServer 'sql.bicep' = {
  name: sqlDBName
  dependsOn: [
    vnet
  ]
  params: {
    azuresqladminlogin: azuresqladminlogin
    azuresqladminpassword: azuresqladminpassword
    location: location
    sqlDBName: sqlDBName
    sqlsubnetId: vnet.outputs.sqlSubnetId
    sqlservername: sqlservername
  }
}

// Deploy Front Door Endpoint
module frontDoorEndpoint 'frontdoor.bicep' = {
  name: 'frontDoorEndpointName'
  params: {
    frontDoorOriginGroupName: frontDoorOriginGroupName
    frontDoorOriginName: frontDoorOriginName
    frontDoorProfileName: frontDoorProfileName
    frontDoorRouteName: frontDoorRouteName
    frontDoorSkuName: frontDoorSkuName
  }
}

// Deploy App Service and Slots
module appService 'appservice.bicep' = {
  name: appServiceName
  dependsOn: [
    vnet
  ]
  params: {
    location: location
    appServiceName: appServiceName
    frontDoorProfileId: frontDoorEndpoint.outputs.frontDoorProfileId
  }
}

// Deploy App Service Slots
resource appServiceSlots 'Microsoft.Web/sites/slots@2021-02-01' = [for slotName in appNameslot: {
  name: '${appServiceName}/${slotName}'
  location: location
  properties: {
    serverFarmId: appService.outputs.serverFarmId
  }
}]

// Deploy Storage Account
module storageAccount 'storageAccount.bicep' = {
  name: storageaccName
  dependsOn: [
    vnet
  ]
  params: {
    storageaccName: storageaccName
    location: location
  }
}


output vnetId string = vnet.outputs.vnetId
output mySQLDatabaseId string = mySQLServer.outputs.mySQLDatabaseId
output mySQLServerId string = mySQLServer.outputs.mySQLServerId
output SQLServerId string = SQLServer.outputs.SQLServerId
output sqlDatabaseId string = SQLServer.outputs.sqlDatabaseId
output frontDoorId string = frontDoorEndpoint.outputs.frontDoorId
output frontDoorEndpointHostName string = frontDoorEndpoint.outputs.frontDoorEndpointHostName
output storageAccountId string = storageAccount.outputs.storageAccountId
output frontDoorProfileId string = frontDoorEndpoint.outputs.frontDoorProfileId
