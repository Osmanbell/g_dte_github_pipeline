using './main.bicep'

param location = 'northeurope'
param myVirtualNetworkName = 'myvnfetidex'
param subnetName = 'appdserf3vice'
param subnet2Name = 'myfs2ld'
param subnet3Name = 'azuredbd2qw'
param keyvaultName = 'azvaddnneqcdra'
param mysqlserverName = 'mynamqjsv2r'
param databaseName = 'myddbddsei1z'
@secure()
param mysqlServerAdministratorLogin = 'nnpcbs1vrez'
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
param azuresqladminlogin = 'azures1qlnbwame'
@secure()
param azuresqladminpassword = 'Pa55word@124'
param sqlDBName = 'sqldbnlwwez'
param sqlservername = 'resvbr1namswez'


param appNameslot = ['slot1','slot2']
param appServiceName = 'NNPC1web'
param frontDoorSkuName = 'Standard_AzureFrontDoor'
param frontDoorProfileName = 'MyFrontDoor'
param frontDoorOriginGroupName = 'MyOriginGroup'
param frontDoorOriginName = 'MyAppServiceOrigin'
param frontDoorRouteName = 'MyRoute'
param storageaccName = 'mysnacsso18e1'






