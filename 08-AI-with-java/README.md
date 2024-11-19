# Create AI-infused Java Apps with Azure OpenAI and Spring AI

In this chapter, we will explore how to create AI-infused Java applications using Azure OpenAI and Spring AI. We will start by configuring our Spring Boot application to connect with Azure OpenAI. Next, we will implement a simple chatbot using Azure OpenAI's GPT-4o model to demonstrate how AI can be seamlessly integrated into Java applications. Additionally, we will cover function calling with Spring AI, allowing our application to perform complex tasks by leveraging AI models.

## Azure OpenAI Integration with Chatbot



```properties
spring.ai.azure.openai.endpoint=
spring.ai.azure.openai.api-key=
```



```bash
cd ~/spring-petclinic-chats-service
mvn clean package
az containerapp create \
  --name chats-service \
  --environment ${ACA_ENVIRONMENT_NAME} \
  --artifact target/chats-service-3.2.11.jar \
  --ingress external \
  --target-port 8080 \
  --query properties.configuration.ingress.fqdn \
  --min-replicas 1 \
  --bind eurekaserver configserver admin
```


## Function Calling with SpringAI




---


## :notebook_with_decorative_cover: Summary

