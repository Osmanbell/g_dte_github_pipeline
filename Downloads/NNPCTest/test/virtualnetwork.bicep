// param location string 
param myVirtualNetworkName string
param subnetName string
param subnet2Name string
param subnet3Name string
// param addressPrefix string = '10.0.0.0/16'
// param subnet1Name string 
// param defaultsubnetPrefix string = '10.0.1.0/24' 
// param databasesubnetPrefix string = '10.0.3.0/24'


resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: myVirtualNetworkName
}

resource mysqlsubnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' existing = {
  parent: vnet
  name: subnetName
}

resource appsubnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' existing = {
  parent: vnet
  name: subnet2Name
}

resource sqlsubnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' existing = {
  parent: vnet
  name: subnet3Name
}


// resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
//   name: myVirtualNetworkName
//   location: location
//   properties: {
//     addressSpace: {
//       addressPrefixes: [
//         addressPrefix
//       ]
//     }
//     subnets: [
//       {
//         name: subnet1Name
//         properties: {
//           addressPrefix: defaultsubnetPrefix
//         }
//       }
//       {
//         name: subnet3Name
//         properties: {
//           addressPrefix: databasesubnetPrefix
//           delegations: [
//             {
//               name: 'mysqlDelegation'
//               properties: {
//                 serviceName: 'Microsoft.DBforMySQL/flexibleServers'
//               }
//             }
//           ]
//         }
//       }
//     ]
//   }
// }

output mysqlsubnetId string = mysqlsubnet.id
output appsubnetId string = appsubnet.id
output sqlsubnetId string = sqlsubnet.id
//output mysqlsubnetId string = '/subscriptions/ca0aa86a-bcd6-4bef-b72c-45302a5515f6/resourceGroups/nnpctest/providers/Microsoft.Network/virtualNetworks/myvnetName/subnets/mysqlsubnet'
//output appsubnetId string = '/subscriptions/ca0aa86a-bcd6-4bef-b72c-45302a5515f6/resourceGroups/nnpctest/providers/Microsoft.Network/virtualNetworks/myvnetName/subnets/appservicesubnet'
//output sqlsubnetId string = '/subscriptions/ca0aa86a-bcd6-4bef-b72c-45302a5515f6/resourceGroups/nnpctest/providers/Microsoft.Network/virtualNetworks/myvnetName/subnets/sqlsubnet'

output vnetId string = vnet.id
// output subnet1Id string = vnet.properties.subnets[0].id
//output subnet2Id string = '/subscriptions/ca0aa86a-bcd6-4bef-b72c-45302a5515f6/resourceGroups/nnpctest/providers/Microsoft.Network/virtualNetworks/myvnetName/subnets/appservicesubnet'
//output subnet3Id string = '/subscriptions/ca0aa86a-bcd6-4bef-b72c-45302a5515f6/resourceGroups/mysql/providers/Microsoft.Network/virtualNetworks/myvnetNamex/subnets/databasesubnet'
//output subnet4Id string = '/subscriptions/ca0aa86a-bcd6-4bef-b72c-45302a5515f6/resourceGroups/nnpctest/providers/Microsoft.Network/virtualNetworks/myvnetName/subnets/appgatewaysubnet'
// output subnet3Id string = resourceId('Microsoft.Network/virtualNetworks/subnets', myVirtualNetworkName, subnet3Name)
// output subnet4Id string = resourceId('Microsoft.Network/virtualNetworks/subnets', myVirtualNetworkName, subnet4Name)
