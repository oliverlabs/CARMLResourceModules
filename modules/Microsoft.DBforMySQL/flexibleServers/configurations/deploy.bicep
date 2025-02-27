@description('Required. The name of the configuration.')
param name string

@description('Conditional. The name of the parent MySQL flexible server. Required if the template is used in a standalone deployment.')
param flexibleServerName string

@description('Optional. Source of the configuration.')
param source string = ''

@description('Optional. Value of the configuration.')
param value string = ''

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource flexibleServer 'Microsoft.DBforMySQL/flexibleServers@2021-12-01-preview' existing = {
  name: flexibleServerName
}

resource configuration 'Microsoft.DBforMySQL/flexibleServers/configurations@2021-12-01-preview' = {
  name: name
  parent: flexibleServer
  properties: {
    source: !empty(source) ? source : null
    value: !empty(value) ? value : null
  }
}

@description('The name of the deployed configuration.')
output name string = configuration.name

@description('The resource ID of the deployed configuration.')
output resourceId string = configuration.id

@description('The resource group of the deployed configuration.')
output resourceGroupName string = resourceGroup().name
