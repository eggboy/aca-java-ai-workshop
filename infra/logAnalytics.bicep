param location string
param logAnalyticsName string = '' // Set in main.parameters.json
var resourceToken = toLower(uniqueString(subscription().id, location))
var abbrs = loadJsonContent('abbreviations.json')

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: !empty(logAnalyticsName) ? logAnalyticsName : '${abbrs.logAnayticsWorkspace}${resourceToken}'
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}

output properties object = logAnalytics.properties
output primarySharedKey string = logAnalytics.listKeys().primarySharedKey