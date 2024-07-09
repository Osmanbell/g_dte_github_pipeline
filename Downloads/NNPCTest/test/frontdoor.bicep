param location string = resourceGroup().location
param appServicePlanName string = 'myAppServicePlan'
param appServicePlanSkuName string = 'S1'
param appServicePlanCapacity int = 1
param appServiceName string = 'myappService-${uniqueString(resourceGroup().id)}'
param frontDoorProfileName string = 'MyFrontDoor'
param frontDoorOriginGroupName string = 'MyAppServiceOrigin'
param frontDoorOriginName string = 'MyAppServiceOrigin'
param frontDoorRouteName string = 'MyRoute'
param appNameslot string = 'myApp'
param frontDoorSkuName string = 'Standard_AzureFrontDoor'

resource frontDoorProfile 'Microsoft.Cdn/profiles@2021-06-01' = {
  name: frontDoorProfileName
  location: 'global'
  sku: {
    name: frontDoorSkuName
  }
}

resource appServicePlan 'Microsoft.Web/serverFarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSkuName
    capacity: appServicePlanCapacity
  }
  kind: 'appService'
}

// resource app 'Microsoft.Web/sites@2020-06-01' = {
//   name: appName
//   location: location
//   kind: 'app'
//   identity: {
//     type: 'SystemAssigned'
//   }
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
//           tag: 'ServiceTag'
//           ipAddress: 'AzureFrontDoor.Backend'
//           action: 'Allow'
//           priority: 100
//           headers: {
//             'x-azure-fdid': [
//               frontDoorProfile.id
//             ]
//           }
//           name: 'Allow traffic from Front Door'
//         }
//       ]
//     }
//   }
// }

// resource appSlot1 'Microsoft.Web/sites@2020-06-01' = {
//   name: '${appNameslot}-slot1'
//   location: location
//   kind: 'app'
//   identity: {
//     type: 'SystemAssigned'
//   }
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
// }

// resource appSlot2 'Microsoft.Web/sites@2020-06-01' = {
//   name: '${appNameslot}-slot2'
//   location: location
//   kind: 'app'
//   identity: {
//     type: 'SystemAssigned'
//   }
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
// }

resource frontDoorEndpoint 'Microsoft.Cdn/profiles/afdEndpoints@2021-06-01' = {
  name: 'afd-myfrontend'
  parent: frontDoorProfile
  location: 'global'
  properties: {
    enabledState: 'Enabled'
  }
}

resource frontDoorOriginGroup 'Microsoft.Cdn/profiles/originGroups@2021-06-01' = {
  name: frontDoorOriginGroupName
  parent: frontDoorProfile
  properties: {
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 3
    }
    healthProbeSettings: {
      probePath: '/'
      probeRequestType: 'HEAD'
      probeProtocol: 'Http'
      probeIntervalInSeconds: 100
    }
  }
}

resource frontDoorOrigin 'Microsoft.Cdn/profiles/originGroups/origins@2021-06-01' = {
  name: frontDoorOriginName
  parent: frontDoorOriginGroup
  properties: {
    hostName: '${appServiceName}.azurewebsites.net'
    httpPort: 80
    httpsPort: 443
    originHostHeader: '${appServiceName}.azurewebsites.net'
    priority: 1
    weight: 1000
  }
}

resource frontDoorRoute 'Microsoft.Cdn/profiles/afdEndpoints/routes@2021-06-01' = {
  name: frontDoorRouteName
  parent: frontDoorEndpoint
  properties: {
    originGroup: {
      id: frontDoorOriginGroup.id
    }
    supportedProtocols: [
      'Http'
      'Https'
    ]
    patternsToMatch: [
      '/*'
    ]
    forwardingProtocol: 'HttpsOnly'
    linkToDefaultDomain: 'Enabled'
    httpsRedirect: 'Enabled'
  }
}

output frontDoorId string = frontDoorProfile.id
output appService string = appService.properties.defaultHostName
output frontDoorEndpointHostName string = frontDoorEndpoint.properties.hostName
