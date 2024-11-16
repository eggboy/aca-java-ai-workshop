# Autoscaling with KEDA(Kubernetes-based Event Driven Autoscaler)

## Objective

In this module, we will accomplish three objectives:

1. Learn about KEDA(Kubernetes Event-Driven Autoscaler)
2. Create a different scaling rule
3. Test scaling of Azure Container Apps

https://azure.github.io/aca-dotnet-workshop/aca/09-aca-autoscale-keda/

## Auto-scaling Options on Azure Container Apps

On Azure Container Apps, there are three different categories
of [scaling triggers](https://learn.microsoft.com/en-us/azure/container-apps/scale-app?pivots=azure-cli).

1. HTTP: Based on the number of concurrent HTTP requests to your revision.
2. TCP: Based on the number of concurrent TCP connections to your revision.
3. Custom(KEDA based): Based on CPU, memory, or supported event-driven data sources such as:

- Azure Service Bus
- Azure Event Hubs
- Apache Kafka
- Redis
- and many more

Custom scaling trigger is using KEDA under the hood, and we will discuss KEDA in the following chapter. 

**Adding or editing scaling rules creates a new revision of your container app.**

## HTTP Scaling Rule

With an HTTP scaling rule, you have control over the threshold of concurrent HTTP requests that determines how your
container app revision scales. Every 15 seconds, the number of concurrent requests is calculated as the number of
requests in the past 15 seconds divided by 15. Let's set the concurrency level as 1, so we can easily simulate the
scaling with our own browser.

Update the scaling rule using Azure CLI. This can be also done on Azure Portal.

```bash
az containerapp update \
  --name helloworld \
  --min-replicas 1 \
  --max-replicas 5 \
  --scale-rule-name azure-http-rule \
  --scale-rule-type http \
  --scale-rule-http-concurrency 1
```

Open the terminal and run `az containerapp logs` to see the increase of replicas.

```bash
az containerapp logs show \
  --name helloworld \
  --type=system \
  --follow=true
```

![System Logs showing the replica no changes](images/http-1.png)

Go to [Azure Portal](https://portal.azure.com) and check the `Revisions and replicas`. in `Replicas`, you should be able
to see multiple replicas.

![System Logs showing the replica no changes](images/http-2.png)

In the Metrics, we can see the total requests per replica.

![System Logs showing the replica no changes](images/http-3.png)


## What is KEDA?

**KEDA** is a Kubernetes-based Event Driven Autoscaler. With KEDA, you can drive the scaling of any container in
Kubernetes based on the number of events needing to be processed.

**KEDA** is a single-purpose and lightweight component that can be added into any Kubernetes cluster. KEDA works
alongside standard Kubernetes components like the Horizontal Pod Autoscaler and can extend functionality without
overwriting or
duplication. With KEDA you can explicitly map the apps you want to use event-driven scale, with other apps continuing to
function. This makes KEDA a flexible and safe option to run alongside any number of any other Kubernetes applications or
frameworks.






## Azure Service Bus Scaling Rule

This time, 


ContainerAppSystemLogs_CL
| where Reason_s == "KEDAScalerFailed"
| project TimeGenerated, ContainerAppName_s, ReplicaName_s, Log_s, Reason_s

---

➡️
Next : [02 - Create a Hello World Spring Boot App and Deploy to Azure Container Apps](../02-deploy-helloworld/README.md)
