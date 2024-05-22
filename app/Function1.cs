using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;
using System;
using System.IO;
using System.Net.Http;
using System.Threading.Tasks;

namespace AzureServiceBusDemo
{
    public static class Function1
    {
        private static readonly HttpClient _httpClient = new HttpClient();

        [FunctionName("Function1")]
        public static async Task Run(
            [TimerTrigger("0 */1 * * * *")] TimerInfo myTimer, // Runs every minute
            [ServiceBus("musicqueue", Connection = "ServiceBusConnection")] IAsyncCollector<string> queueCollector,
            [Blob("mycontainer/{rand-guid}.json", FileAccess.Write, Connection = "AzureWebJobsStorage")] Stream outputBlob,
            ILogger log)
        {
            log.LogInformation($"SendMessage function executed at: {DateTime.Now}");

            string apiEndpoint = "http://www.theaudiodb.com/api/v1/json/2/search.php?s=coldplay";

            HttpResponseMessage response = await _httpClient.GetAsync(apiEndpoint);
            if (!response.IsSuccessStatusCode)
            {
                log.LogError($"Failed to fetch data from API. StatusCode: {response.StatusCode}");
                return;
            }

            string responseBody = await response.Content.ReadAsStringAsync();
            log.LogInformation($"API Response: {responseBody}");

            await queueCollector.AddAsync(responseBody);

            using (StreamWriter writer = new StreamWriter(outputBlob))
            {
                await writer.WriteAsync(responseBody);
            }

            log.LogInformation("Message sent to Azure Service Bus queue and saved to blob storage.");
        }
    }
}
