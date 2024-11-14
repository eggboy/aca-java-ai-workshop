# Use Managed Java Component on Azure Container Apps
---

## Create a Managed Eureka Server

A key feature of cloud-native application is *service discovery* - the ability to provide a common place to find and
identify individual services. In this section, we'll create
a [Spring Cloud Eureka Server](https://spring.io/projects/spring-cloud-netflix) to enable this functionality.

Define the environment variables.

```bash
EUREKA_SERVER_NAME="eurekaserver01"
```

Create the Managed Eureka Server.

```bash
az containerapp env java-component eureka-server-for-spring create \
  --environment $ENVIRONMENT \
  --resource-group $RESOURCE_GROUP \
  --name $EUREKA_SERVER_NAME
```

## Create a Managed Config Server

Another key feature of cloud-native applications is *externalized configuration* - the ability to store, manage, and
version configuration separately from the application code. In this section, we'll create and configure
a [Spring Cloud Config Server](https://spring.io/projects/spring-cloud-config) to enable this functionality. In the next
section, you'll see how Spring Cloud Config can inject configuration from a Git repository into your application.

To use this shortcut:

1. Define the following environment variables.
   ```bash
   CONFIG_SERVER_NAME="configserver01"
   GIT_URL="https://github.com/Azure-Samples/java-on-aca-sample-public-config.git"
   ```
2. Create the Managed Config Server for Spring and set its configuration source as the public Git repository.
   ```bash
   az containerapp env java-component config-server-for-spring create \
   --environment $ENVIRONMENT \
   --resource-group $RESOURCE_GROUP \
   --name $CONFIG_SERVER_NAME \
   --configuration spring.cloud.config.server.git.uri=$GIT_URL
   ```

## Create a Managed Spring Boot Admin
