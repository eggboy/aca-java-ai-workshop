targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the the environment which is used to generate a short unique hash used in all resources.')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
@allowed(['koreacentral', 'southeastasia'])
@metadata({
  azd: {
    type: 'location'
  }
})
param location string

param resourceGroupName string = '' // Set in main.parameters.json

@secure()
param openAiServiceName string = ''

@description('Location for the OpenAI resource group')
@allowed([
  'eastus'
  'eastus2'
  'northcentralus'
  'southcentralus'
  'swedencentral'
  'westus'
  'westus3'
])
@metadata({
  azd: {
    type: 'location'
  }
})
param openAiResourceGroupLocation string

param azureOpenAiSkuName string = '' // Set in main.parameters.json

param logAnalyticsName string = '' // Set in main.parameters.json

param azureOpenAiDeploymentName string = '' // Set in main.parameters.json
param azureOpenAiDeploymentSkuName string = '' // Set in main.parameters.json
param azureOpenAiDeploymentVersion string = '' // Set in main.parameters.json
param azureOpenAiDeploymentCapacity int = 0 // Set in main.parameters.json
var gpt4o = {
  modelName: 'gpt-4o'
  deploymentName: !empty(azureOpenAiDeploymentName) ? azureOpenAiDeploymentName : 'gpt-4o'
  deploymentVersion: !empty(azureOpenAiDeploymentVersion) ? azureOpenAiDeploymentVersion : '2024-08-06'
  deploymentSkuName: !empty(azureOpenAiDeploymentSkuName) ? azureOpenAiDeploymentSkuName : 'Standard'
  deploymentCapacity: azureOpenAiDeploymentCapacity != 0 ? azureOpenAiDeploymentCapacity : 30
}


param tenantId string = tenant().tenantId

@allowed(['None', 'AzureServices'])
@description('If allowedIp is set, whether azure services are allowed to bypass the storage and AI services firewall.')
param bypass string = 'AzureServices'

@description('Public network access value for all deployed resources')
@allowed(['Enabled', 'Disabled'])
param publicNetworkAccess string = 'Enabled'

var abbrs = loadJsonContent('abbreviations.json')
var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))
var tags = { 'azd-env-name': environmentName }

// Organize resources in a resource group
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'aca-labs'
  location: location
  tags: tags
}

var defaultOpenAiDeployments = [
  {
    name: gpt4o.deploymentName
    model: {
      format: 'OpenAI'
      name: gpt4o.modelName
      version: gpt4o.deploymentVersion
    }
    sku: {
      name: gpt4o.deploymentSkuName
      capacity: gpt4o.deploymentCapacity
    }
  }

]

module openAi 'br/public:avm/res/cognitive-services/account:0.7.2' = {
  name: 'openai'
  scope: resourceGroup
  params: {
    name: '${abbrs.cognitiveServicesAccounts}${resourceToken}'
    location: openAiResourceGroupLocation
    tags: tags
    kind: 'OpenAI'
    customSubDomainName: !empty(openAiServiceName)
      ? openAiServiceName
      : '${abbrs.cognitiveServicesAccounts}${resourceToken}'
    publicNetworkAccess: publicNetworkAccess
    networkAcls: {
      defaultAction: 'Allow'
      bypass: bypass
    }
    sku: azureOpenAiSkuName
    deployments: defaultOpenAiDeployments
    disableLocalAuth: false
    managedIdentities: {
      systemAssigned: true
    }
  }
}


module workspace 'br/public:avm/res/operational-insights/workspace:0.7.0' = {
  name: 'loganalytics'
  scope: resourceGroup
  params: {
    name: !empty(logAnalyticsName) ? logAnalyticsName : '${abbrs.logAnayticsWorkspace}${resourceToken}'
    location: location
    tags: tags
    publicNetworkAccessForIngestion: publicNetworkAccess
  }
}


module managedEnvironment 'br/public:avm/res/app/managed-environment:0.8.1' = {
  name: 'managedEnvironmentDeployment'
  scope: resourceGroup
  params: {
    // Required parameters
    logAnalyticsWorkspaceResourceId: workspace.outputs.resourceId
    name: '${abbrs.contaienrAppsEnvironments}${resourceToken}'
    zoneRedundant: false
  }
}

module flexibleServer 'br/public:avm/res/db-for-my-sql/flexible-server:0.4.1' = {
  name: 'flexibleServerDeployment'
  scope: resourceGroup
  params: {
    name: '${abbrs.dBforMySQLServers}${resourceToken}'
    skuName: 'Standard_D2ds_v4'
    tier: 'GeneralPurpose'
    administratorLogin: 'acaadmin'
    administratorLoginPassword:  '${abbrs.dBforMySQLServers}${resourceToken}'
    location: location
    storageAutoGrow: 'Enabled'
  }
}



output AZURE_LOCATION string = location
output AZURE_TENANT_ID string = tenantId
output AZURE_RESOURCE_GROUP string = resourceGroup.name

// Shared by all OpenAI deployments
output AZURE_OPENAI_OPENAI_MODEL string = gpt4o.modelName

// Specific to Azure OpenAI
output AZURE_OPENAI_SERVICE_NAME string = openAi.outputs.name
output AZURE_OPENAI_DEPLOYMENT_NAME string = gpt4o.deploymentName

// Output for the labs
output AZURE_OPENAI_ENDPOINT string = openAi.outputs.endpoint
output AZURE_OPENAI_API_KEY object = openAi.outputs.exportedSecrets

output AZURE_CONTAINER_APPS_MANAGED_ENVIRONMENT string = managedEnvironment.outputs.name
