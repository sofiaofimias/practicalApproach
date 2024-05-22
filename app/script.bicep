@description('Location for all resources.')
param location string = resourceGroup().location

param locationForIntegrationAcc string 

@description('Name of the Service Bus namespace')
param serviceBusNamespaceName string

@description('Name of the Queue')
param serviceBusQueueName string

@description('Name of the Function App')
param funcAppName string

@description('Name of the storage account')
param stg string

@description('Cosmos DB account name')
param accountName string

@description('The name for the SQL API database')
param databaseName string

@description('The name for the SQL API container')
param containerName string

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: stg
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'

}

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2022-01-01-preview' = {
  name: serviceBusNamespaceName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {}
}

resource serviceBusQueue 'Microsoft.ServiceBus/namespaces/queues@2022-01-01-preview' = {
  parent: serviceBusNamespace
  name: serviceBusQueueName
  properties: {
    lockDuration: 'PT5M'
    maxSizeInMegabytes: 1024
    requiresDuplicateDetection: false
    requiresSession: false
    defaultMessageTimeToLive: 'P10675199DT2H48M5.4775807S'
    deadLetteringOnMessageExpiration: false
    duplicateDetectionHistoryTimeWindow: 'PT10M'
    maxDeliveryCount: 10
    autoDeleteOnIdle: 'P10675199DT2H48M5.4775807S'
    enablePartitioning: false
    enableExpress: false
  }
}

// Add other resources as needed...



// param storageAccountName string = 'sofiastorageaccount'
// param cosmosDBAccountName string = 'ofimias3cosmosdb'
// param databaseName string = 'musicData'
// param collectionName string = 'artists'
// param serviceBusNamespaceName string = 'sofiaservicebus2'
// param queueName string = 'musicQueue'
// param logicAppName string = 'musicQueueLogicApp'
// param logicAppLocation string = 'northeurope'

// resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
//   name: storageAccountName
//   location: 'northeurope'
//   sku: {
//     name: 'Standard_LRS'
//   }
//   kind: 'StorageV2'
//   properties: {
//     accessTier: 'Hot'
//   }
// }

// // resource cosmosDB 'Microsoft.DocumentDB/databaseAccounts@2021-04-15' = {
// //   name: cosmosDBAccountName
// //   location: 'northeurope'
// //   kind: 'MongoDB' 
// //   properties: {
// //     databaseAccountOfferType: 'Standard'
// //   }
// // }

// // resource database 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases@2022-05-15' = {
// //   parent: cosmosDB
// //   name: databaseName
// //   properties: {
// //     resource: {
// //       id: databaseName
// //     }
// //     options: {
// //       autoscaleSettings: {
// //         maxThroughput: 4000 
// //       }
// //     }
// //   }
// // }

// // resource collection 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections@2022-05-15' = {
// //   parent: database
// //   name: collectionName
// //   properties: {
// //     resource: {
// //       id: collectionName
// //       shardKey: {
// //         user_id: 'Hash'
// //       }
// //       indexes: [
// //         {
// //           key: {
// //             keys: [
// //               '_id'
// //             ]
// //           }
// //         }
// //         {
// //           key: {
// //             keys: [
// //               '$**'
// //             ]
// //           }
// //         }
// //         {
// //           key: {
// //             keys: [
// //               'product_name'
// //               'product_category_name'
// //             ]
// //           }
// //         }
// //       ]
// //     }
// //   }
// // }

// resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2017-04-01' = {
//   name: serviceBusNamespaceName
//   location: 'northeurope'
//   sku: {
//     name: 'Standard'
//     tier: 'Standard'
//   }
// }

// resource queue 'Microsoft.ServiceBus/namespaces/queues@2017-04-01' = {
//   parent: serviceBusNamespace
//   name: queueName
//   properties: {
//     enablePartitioning: true
//     maxSizeInMegabytes: 1024
//     defaultMessageTtl: 'PT1H'
//     lockDuration: 'PT5M'
//   }
// }

// // resource logicApp 'Microsoft.Logic/workflows@2017-07-01' = {
// //   name: logicAppName
// //   location: logicAppLocation
// //   properties: {
// //     definition: {
// //       '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
// //       actions: {
// //         // Configure trigger for when a message is received in the queue
// //         'When_a_message_is_received_in_a_queue_(Azure_Service_Bus)': {
// //           type: 'ServiceBus'
// //           inputs: {
// //             host: {
// //               connectionString: 'Endpoint=sb://sofiaservicebus2.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=x6lRUDDJbM8rprPLWgsugfYsXWHOi5YDk+ASbAWPplE='
// //             }
// //             method: 'get'
// //             path: '/@{encodeURIComponent(\'musicQueue\')}'
// //           }
// //           runAfter: {}
// //           metadata: {
// //             'flowSystemIntegration': 'None'
// //           }
// //         }
// //         // // Add action to send data to MongoDB
// //         // 'HTTP': {
// //         //   type: 'Http'
// //         //   inputs: {
// //         //     method: 'POST'
// //         //     uri: 'YOUR_MONGODB_API_ENDPOINT'
// //         //     body: {
// //         //       // Define your payload transformation here if needed
// //         //     }
// //         //   }
// //         //   runAfter: {
// //         //     'When_a_message_is_received_in_a_queue_(Azure_Service_Bus)': ['Succeeded']
// //         //   }
// //         //   metadata: {
// //         //     'flowSystemIntegration': 'None'
// //         //   }
// //         // }
// //       }
// //       outputs: {}
// //     }
// //     parameters: {}
// //     triggers: {
// //       'manual': {
// //         type: 'Request'
// //         kind: 'Http'
// //       }
// //     }
// //   }
// // }
