# Create AI-infused Java Apps with Azure OpenAI and Spring AI

In this chapter, we will explore how to create AI-infused Java applications using Azure OpenAI and Spring AI. We will start by configuring our Spring Boot application to connect with Azure OpenAI. Next, we will implement a simple chatbot using Azure OpenAI's GPT-4o model to demonstrate how AI can be seamlessly integrated into Java applications. Additionally, we will cover function calling with Spring AI, allowing our application to perform complex tasks by leveraging AI models.

---

In this module, we'll focus on two key objectives:
1. :white_check_mark: Integrate Azure OpenAI with Chatbot.
2. :bar_chart: Use Function Calling to implement basic RAG with Spring AI.

## Azure OpenAI Integration with Chatbot


Replace the ${AZURE_OPENAI_API_KEY} and ${AZURE_OPENAI_ENDPOINT} with your Azure OpenAI API key and endpoint.

```yaml
spring:
  application:
    name: chats-service
  config:
    import: optional:configserver:${CONFIG_SERVER_URL:http://localhost:8888/}
  ai:
    azure:
      openai:
        api-key: ${AZURE_OPENAI_API_KEY}
        endpoint: ${AZURE_OPENAI_ENDPOINT}
        chat:
          options:
            model: gpt-4o
```


Create a Chatclient using AzureOpenAiChatClient in one single class in ChatController class



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

