param location string = resourceGroup().location
param appServicePlanName string = 'myAppServicePlan'
param appServicePlanSkuName string = 'S1'
param appServicePlanCapacity int = 1
param appServiceName string = 'myappService-${uniqueString(resourceGroup().id)}'
// param appNameslot array = ['slot1', 'slot2'] // Changed to an array to handle multiple slots
param frontDoorProfileId string

resource appServicePlan 'Microsoft.Web/serverFarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSkuName
    capacity: appServicePlanCapacity
  }
  kind: 'appService'
}

resource appService 'Microsoft.Web/sites@2020-06-01' = {
  name: appServiceName
  location: location
  kind: 'app'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      detailedErrorLoggingEnabled: true
      httpLoggingEnabled: true
      requestTracingEnabled: true
      ftpsState: 'Disabled'
      minTlsVersion: '1.2'
      ipSecurityRestrictions: [
        {
          tag: 'ServiceTag'
          ipAddress: 'AzureFrontDoor.Backend'
          action: 'Allow'
          priority: 100
          headers: {
            'x-azure-fdid': [
              frontDoorProfileId
            ]
          }
          name: 'Allow traffic from Front Door'
        }
      ]
    }
  }
}

// Deploy App Service Slots
// resource appServiceSlots 'Microsoft.Web/sites/slots@2021-02-01' = [for slotName in appNameslot: {
//   name: '${appServiceName}/${slotName}'
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
//     }
//   }
// }]

output serverFarmId string = appServicePlan.id
