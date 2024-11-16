# Create Managed Java Component on Azure Container Apps

Azure Container Apps provides several managed component which could help customers running Spring Boot in production. There are in total 3 managed components, Eureka Server, Config Server, and Spring Boot Admin.

---

## Create a Managed Eureka Server

A key feature of cloud-native application is *service discovery* - the ability to provide a common place to find and identify individual services. In this section, we'll create a [Spring Cloud Eureka Server](https://spring.io/projects/spring-cloud-netflix) to enable this functionality.

1. Define the environment variables.

```bash
EUREKA_SERVER_NAME="eurekaserver"
```

2. Create the Managed Eureka Server.

```bash
az containerapp env java-component eureka-server-for-spring create \
  --environment ${ACA_ENVIRONMENT_NAME} \
  --name ${EUREKA_SERVER_NAME} \
  --query properties.ingress.fqdn -o tsv
```

3. Access Eureka Dashboard using the FQDN returned by above command.
![Spring Boot Admin](images/eureka-web.png)

## Create a Managed Config Server

Another key feature of cloud-native applications is *externalized configuration* - the ability to store, manage, and version configuration separately from the application code. In this section, we'll create and configure a [Spring Cloud Config Server](https://spring.io/projects/spring-cloud-config) to enable this functionality. In the next section, you'll see how Spring Cloud Config can inject configuration from a Git repository into your application.

To use this shortcut:

1. Define the following environment variables.
   ```bash
   CONFIG_SERVER_NAME="configserver"
   GIT_URL="https://github.com/azure-samples/spring-petclinic-microservices-config"
   ```
2. Create the Managed Config Server for Spring and set its configuration source as the public Git repository.
   ```bash
   az containerapp env java-component config-server-for-spring create \
   --environment ${ACA_ENVIRONMENT_NAME} \
   --name ${CONFIG_SERVER_NAME} \
   --configuration spring.cloud.config.server.git.uri=$GIT_URL spring.cloud.config.server.git.refresh-rate=60
   ```

## Create a Managed Spring Boot Admin

The Admin for Spring managed component offers an administrative interface for Spring Boot web applications that expose actuator endpoints. As a managed component in Azure Container Apps, you can easily bind your container app to Admin for Spring for seamless integration and management.

1. Define the following environment variables.
   ```bash
   SPRING_ADMIN_NAME="admin"
   ```
2. Create the Managed Config Server for Spring and set its configuration source as the public Git repository.

```bash
az containerapp env java-component admin-for-spring create \
--environment ${ACA_ENVIRONMENT_NAME}  \
--name ${SPRING_ADMIN_NAME} \
  --min-replicas 1 \
  --max-replicas 1 \
--query properties.ingress.fqdn -o tsv
```
3. Access Spring Boot Admin console using FQDN returned from the command above. Spring Boot Admin is by default secured by Azure Entra ID.

![Spring Boot Admin](images/admin-fqdn.png)
![Spring Boot Admin](images/admin-web.png)

---

➡️ Next : [02 - Create a Hello World Spring Boot App and Deploy to Azure Container Apps](../02-deploy-helloworld/README.md)