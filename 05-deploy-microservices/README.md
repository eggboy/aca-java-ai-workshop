# Deploy Microservices

For the lab, we will deploy the backend microservices of the Spring PetClinic application. The backend microservices are
the `customers-service`, `visits-service`, and `vets-service`. These services are built using Spring Boot and are part of the
Spring PetClinic application. The frontend microservice is `api-gateway` which is built using Angular and Spring Cloud Gateway. 

![PetClinic Spring Apps](images/petclinic.png)

By default, the Spring PetClinic application uses an in-memory database, but we will use Azure Database for MySQL
Flexible Server as the database for the backend services in chapter 06. Also, each service are bound to Eureka Server,
so that UI+API Gateway can discover the services through Eureka Server.

## Deploy Backend Services

We're going to deploy 3 microservices on Azure Container Apps, customers-service, visits-service, and vets-service. This
time, we will deploy each services with artifact and bind them to Eureka Server and Config Server. You can bind/unbind
Java components during deployment, or after deployment. Here, we will bind it after deployment for the example.

### Deploy `customers-service`

First, build the project using maven and deploy it with `az containerapp create` command.

```bash
cd spring-petclinic-customers-service
mvn clean package
az containerapp create \
  --name customers-service \
  --environment ${ACA_ENVIRONMENT_NAME} \
  --artifact target/customers-service-3.2.11.jar \
  --ingress external \
  --target-port 8080 \
  --query properties.configuration.ingress.fqdn \
  --min-replicas 1
```

Bind the Eureka Server and Config Server to the customers-service.

```bash
az containerapp update \
    --name customers-service \
    --bind eurekaserver configserver springadmin
```

### Deploy `visits-service`

First, build the project using maven and deploy it with `az containerapp create` command.

    ```bash
    cd spring-petclinic-visits-service
    mvn clean package
    az containerapp create \
      --name visits-service \
      --environment ${ACA_ENVIRONMENT_NAME} \
      --artifact target/visits-service-3.2.11.jar \
      --ingress external \
      --target-port 8080 \
      --query properties.configuration.ingress.fqdn \
      --min-replicas 1 \
      --bind eurekaserver configserver admin
    ```

### Deploy `vets-service`

Build the project using maven and deploy it with `az containerapp create` command.

    ```bash
    cd spring-petclinic-vets-service
    mvn clean package
    az containerapp create \
      --name vets-service \
      --environment ${ACA_ENVIRONMENT_NAME} \
      --artifact target/vets-service-3.2.11.jar \
      --ingress external \
      --target-port 8080 \
      --query properties.configuration.ingress.fqdn \
      --min-replicas 1 \
      --bind eurekaserver configserver admin
    ```

## Deploy Frontend Service

Build the project using maven and deploy it with `az containerapp create` command.

    ```bash
    cd spring-petclinic-api-gateway
    mvn clean package
    az containerapp create \
      --name vets-service \
      --environment ${ACA_ENVIRONMENT_NAME} \
      --artifact target/api-gateway-3.2.11.jar \
      --ingress external \
      --target-port 8080 \
      --query properties.configuration.ingress.fqdn \
      --min-replicas 1 \
      --bind eurekaserver configserver admin
    ```

## Explore Java Components Binding

We bound the Java components to the Eureka Server and Config Server to each Container Apps. Binding Java components to
Container apps is to connect the Java components to the Container Apps, and under the hood, it injects the various
environment variables to the Container Apps.

For an example of binding Eureka Server, those environment variables are set as seen below.

![Eureka Env Variables](images/eureka-1.png)

For an example of binding Config Server, those environment variables as seen below.

![Config Server Env Variables](images/config-1.png)

---

➡️ Next : [02 - Create a Hello World Spring Boot App and Deploy to Azure Container Apps](../02-deploy-helloworld/README.md)
