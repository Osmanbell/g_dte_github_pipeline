param location string 
param myVirtualNetworkName string 
param subnetName string
param subnet2Name string
param subnet3Name string
@secure()
param mysqlServerAdministratorLogin string
@secure()
param mysqlServerAdministratorPassword string
param mysqlVersion string 
param skuName string 
param SkuTier string 
param storageSizeGB int 
param storageIops int 
param storageAutogrow string
param backupRetentionDays int 
param geoRedundantBackup string
param keyvaultName string 
// param firewallRules array 
param mysqlserverName string
param databaseName string
param azuresqladminlogin string
@secure()
param azuresqladminpassword string
param sqlDBName string
param sqlservername string
param appServicePlanName string
param appServicePlanSkuName string
param appServicePlanCapacity int
param appServiceName string
param appNameslot string
param frontDoorEndpointName string
param frontDoorProfileName string
param frontDoorSkuName string
param frontDoorOriginGroupName string
param frontDoorOriginName string
param frontDoorRouteName string
param storageaccName string

// Deploy virtual network
module vnet 'virtualnetwork.bicep' = {
  name: myVirtualNetworkName
  params: {
    myVirtualNetworkName: myVirtualNetworkName
    subnetName: subnetName
    subnet3Name: subnet3Name
    subnet2Name: subnet2Name
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
    mysqlsubnetId: vnet.outputs.mysqlsubnetId
    backupRetentionDays: backupRetentionDays
    // firewallRules: firewallRules
    geoRedundantBackup: geoRedundantBackup
    mysqlVersion: mysqlVersion
    skuName: skuName
    SkuTier: SkuTier
    storageAutogrow: storageAutogrow
    storageIops: storageIops
    storageSizeGB: storageSizeGB
  }
}
module keyvault 'keyvault.bicep' = {
  name:keyvaultName
  dependsOn: [
    vnet
  ]
  params: {
    keyvaultName:keyvaultName
    location:location
  }
 
}


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
    sqlsubnetId: vnet.outputs.sqlsubnetId
    sqlservername: sqlservername
  }
}

module frontDoorEndpoint 'frontdoor.bicep' = {
  name: 'frontDoorEndpointName'
  params: {
  frontDoorOriginGroupName: frontDoorOriginGroupName
  frontDoorOriginName: frontDoorOriginName
  frontDoorProfileName: frontDoorProfileName
  frontDoorRouteName: frontDoorRouteName
  frontDoorSkuName: frontDoorSkuName
  appNameslot: appNameslot
  appServiceName: appServiceName
  appServicePlanCapacity: appServicePlanCapacity
  appServicePlanName: appServicePlanName
  appServicePlanSkuName: appServicePlanSkuName
  location: location
  }
  }


  // Deploy App Service and Slots
module appService './appservice.bicep' = {
  name: 'appServiceName'
  dependsOn: [
    appServicePlan
  ]
  params: {
    location: location
    appServicePlanId: appServicePlan.id
    appSeviceName: appServiceName
    appNameslot: appNameslot
    frontDoorProfileId: frontDoorEndpoint.outputs.frontDoorProfileId
  }
}

resource appSlot1 'Microsoft.Web/sites@2020-06-01' = {
  name: '${appNameslot}-slot1'
  location: location
  kind: 'appService'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlanId
    httpsOnly: true
    siteConfig: {
      detailedErrorLoggingEnabled: true
      httpLoggingEnabled: true
      requestTracingEnabled: true
      ftpsState: 'Disabled'
      minTlsVersion: '1.2'
    }
  }
}

resource appSlot2 'Microsoft.Web/sites@2020-06-01' = {
  name: '${appNameslot}-slot2'
  location: location
  kind: 'appService'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlanId
    httpsOnly: true
    siteConfig: {
      detailedErrorLoggingEnabled: true
      httpLoggingEnabled: true
      requestTracingEnabled: true
      ftpsState: 'Disabled'
      minTlsVersion: '1.2'
    }
  }
}

resource appServicePlan 'Microsoft.Web/serverFarms@2020-12-01' = {
  name: appServicePlanName
  location: location
  kind: 'app'
  sku: {
    name: appServicePlanSkuName
    capacity: appServicePlanCapacity
  }
}



// Deploy Storage Account
module storageAccount './storageAccount.bicep' = {
  name: storageaccName
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
  output appServiceHostName string = frontDoorEndpoint.outputs.appServiceHostName
  output frontDoorEndpointHostName string = frontDoorEndpoint.outputs.frontDoorEndpointHostName
  output storageAccountId string = storageAccount.outputs.storageAccountId

