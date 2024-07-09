using './main.bicep'

param location = 'northeurope'
param myVirtualNetworkName = 'myvnfetNamex'
param subnetName = 'appssdservice'
param subnet2Name = 'mysqld'
param subnet3Name = 'azuredbdd'
param keyvaultName = 'azurekeyvaddweultuy11943'
param mysqlserverName = 'mynamesv2r'
param databaseName = 'myddbsvr1z'
@secure()
param mysqlServerAdministratorLogin = 'promizes1vrz'
@secure()
param mysqlServerAdministratorPassword = 'password@123'
param mysqlVersion = '5.7'
param skuName = 'GP_Gen5_2' // Changed to a valid MySQL SKU
param SkuTier = 'GeneralPurpose'
param storageSizeGB = 20
param storageIops = 360
@allowed([
  'Enabled'
  'Disabled'
])
param storageAutogrow = 'Enabled'
param backupRetentionDays = 7
param geoRedundantBackup = 'Disabled'
param azuresqladminlogin = 'azures1qlname'
@secure()
param azuresqladminpassword = 'Pa55word@124'
param sqlDBName = 'sqldbn1amez'
param sqlservername = 'azuresvr1namez'
param appServicePlanName = 'serviceplanN1name'
param appServicePlanSkuName = 'S1' // Changed to a valid App Service Plan SKU
param appServicePlanCapacity = 1
param appNameslot = 'myApp(slot1|slot2)'
param appServiceName = 'NNPC1web'
param frontDoorEndpointName = 'afd-Standard_AzureFrontDoor'
param frontDoorSkuName = 'Standard_AzureFrontDoor'
param frontDoorProfileName = 'MyFrontDoor'
param frontDoorOriginGroupName = 'MyOriginGroup'
param frontDoorOriginName = 'MyAppServiceOrigin'
param frontDoorRouteName = 'MyRoute'
param storageaccName = 'mystorageacssscount'

// param sqlLocation = 'westus' // Change location for SQL Server




// using './main.bicep'

// param location = 'eastus'
// param myVirtualNetworkName = 'myvnetNamex'
// param subnetName = 'appservice'
// param subnet2Name = 'mysql'
// param subnet3Name = 'azuredb'
// param keyvaultName = 'azurekeyvault'
// param mysqlserverName = 'mynamesvr'
// param databaseName = 'mydbsvrz'
// @secure()
// param mysqlServerAdministratorLogin = 'promizesvrz'
// @secure()
// param mysqlServerAdministratorPassword = 'password@123'
// param mysqlVersion = '5.7'
// param skuName = 'GP_Gen5_2' // Valid MySQL SKU
// param SkuTier = 'GeneralPurpose'
// param storageSizeGB = 20
// param storageIops = 360
// @allowed([
//   'Enabled'
//   'Disabled'
// ])
// param storageAutogrow = 'Enabled'
// param backupRetentionDays = 7
// param geoRedundantBackup = 'Disabled'
// param azuresqladminlogin = 'azuresqlname'
// @secure()
// param azuresqladminpassword = 'Pa55word@124'
// param sqlDBName = 'sqldbnamez'
// param sqlservername = 'azuresvrnamez'
// param appServicePlanName = 'serviceplanNname'
// param appServicePlanSkuName = 'S1' // Valid App Service Plan SKU
// param appServicePlanCapacity = 1
// param appNameslot = 'myApp(slot1|slot2)'
// param appName = 'NNPCweb'
// param frontDoorEndpointName = 'afd-Standard_AzureFrontDoor'
// param frontDoorSkuName = 'Standard_AzureFrontDoor'
// param frontDoorProfileName = 'MyFrontDoor'
// param frontDoorOriginGroupName = 'MyOriginGroup'
// param frontDoorOriginName = 'MyAppServiceOrigin'
// param frontDoorRouteName = 'MyRoute'
// param sqlLocation = 'westus' // Change location for SQL Server

// resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' = {
//   name: keyvaultName
//   location: location
//   properties: {
//     sku: {
//       family: 'A'
//       name: 'standard'
//     }
//     tenantId: subscription().tenantId
//     accessPolicies: []
//   }
// }

// resource appServicePlan 'Microsoft.Web/serverFarms@2020-12-01' = {
//   name: appServicePlanName
//   location: location
//   sku: {
//     name: appServicePlanSkuName
//     capacity: appServicePlanCapacity
//   }
// }

// resource app 'Microsoft.Web/sites@2020-12-01' = {
//   name: appName
//   location: location
//   properties: {
//     serverFarmId: appServicePlan.id
//     httpsOnly: true
//     siteConfig: {
//       detailedErrorLoggingEnabled: true
//       httpLoggingEnabled: true
//       requestTracingEnabled: true
//       ftpsState: 'Disabled'
//       minTlsVersion: '1.2'
//       ipSecurityRestrictions: [
//         {
//           ipAddress: '*'
//           action: 'Allow'
//           priority: 100
//           name: 'Allow all'
//         }
//       ]
//     }
//   }
// }

// resource sqlServer 'Microsoft.Sql/servers@2021-02-01-preview' = {
//   name: sqlservername
//   location: sqlLocation // Use valid location for SQL Server
//   properties: {
//     administratorLogin: azuresqladminlogin
//     administratorLoginPassword: azuresqladminpassword
//   }
// }

// resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
//   name: '${sqlservername}/${sqlDBName}'
//   properties: {
//     collation: 'SQL_Latin1_General_CP1_CI_AS'
//     maxSizeBytes: 2147483648
//   }
// }

// resource mySQLServer 'Microsoft.DBforMySQL/servers@2021-05-01' = {
//   name: mysqlserverName
//   location: location
//   sku: {
//     name: skuName
//     tier: SkuTier
//   }
//   properties: {
//     administratorLogin: mysqlServerAdministratorLogin
//     administratorLoginPassword: mysqlServerAdministratorPassword
//     version: mysqlVersion
//     storageProfile: {
//       storageMB: storageSizeGB * 1024
//       backupRetentionDays: backupRetentionDays
//       geoRedundantBackup: geoRedundantBackup
//       storageAutogrow: storageAutogrow
//       iops: storageIops
//     }
//   }
// }

// resource frontDoorProfile 'Microsoft.Cdn/profiles@2020-09-01' = {
//   name: frontDoorProfileName
//   location: 'global'
//   sku: {
//     name: frontDoorSkuName
//   }
// }

// resource frontDoorEndpoint 'Microsoft.Cdn/profiles/endpoints@2020-09-01' = {
//   name: frontDoorEndpointName
//   parent: frontDoorProfile
//   location: 'global'
//   properties: {
//     enabledState: 'Enabled'
//   }
// }
