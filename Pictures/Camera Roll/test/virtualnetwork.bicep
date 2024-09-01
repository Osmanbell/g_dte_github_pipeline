@description('Specifies the name of the virtual network.')
param myVirtualNetworkName string

@description('Specifies the name of the subnet for the App Service.')
param subnetName string

@description('Specifies the name of the subnet for the MySQL Database.')
param subnet2Name string

@description('Specifies the name of the subnet for the SQL Server.')
param subnet3Name string

@description('Specifies the address space for the virtual network.')
param addressSpace string = '10.0.0.0/16'

@description('Specifies the address prefix for the App Service subnet.')
param subnetPrefix string = '10.0.1.0/24'

@description('Specifies the address prefix for the MySQL subnet.')
param subnet2Prefix string = '10.0.2.0/24'

@description('Specifies the address prefix for the SQL Server subnet.')
param subnet3Prefix string = '10.0.3.0/24'

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: myVirtualNetworkName
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [addressSpace]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefix
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: subnet2Prefix
        }
      }
      {
        name: subnet3Name
        properties: {
          addressPrefix: subnet3Prefix
        }
      }
    ]
  }
}

output vnetId string = vnet.id
output appSubnetId string = vnet.properties.subnets[0].id
output mysqlSubnetId string = vnet.properties.subnets[1].id
output sqlSubnetId string = vnet.properties.subnets[2].id
