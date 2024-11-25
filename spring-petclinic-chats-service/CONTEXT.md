These are code sample to make use of Spring AI for Azure OpenAI.

## AzureOpenAiChatModel Usage

Below is the test case from Spring AI for Azure OpenAI. This test case is used to test the chat model with the Azure OpenAI endpoint.

```java
package org.springframework.samples.petclinic.chats;

import com.azure.ai.openai.OpenAIClientBuilder;
import com.azure.ai.openai.OpenAIServiceVersion;
import com.azure.core.credential.AzureKeyCredential;
import com.azure.core.http.policy.HttpLogOptions;
import org.junit.jupiter.api.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.azure.openai.AzureOpenAiChatModel;
import org.springframework.ai.azure.openai.AzureOpenAiChatOptions;
import org.springframework.ai.chat.messages.Message;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.ai.chat.model.ChatResponse;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.ai.chat.prompt.SystemPromptTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringBootConfiguration;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Bean;

import java.util.List;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(classes = AzureOpenAiChatModelIT.TestConfiguration.class)
class AzureOpenAiChatModelIT {

    private static final Logger logger = LoggerFactory.getLogger(AzureOpenAiChatModelIT.class);

    @Autowired
    private AzureOpenAiChatModel chatModel;

    @Test
    void roleTest() {
        Message systemMessage = new SystemPromptTemplate("""
                                                                 You are a helpful AI assistant. Your name is {name}.
                                                                 You are an AI assistant that helps people find information.
                                                                 Your name is {name}
                                                                 You should reply to the user's request with your name and also in the style of a {voice}.
                                                                 """).createMessage(Map.of("name", "Bob", "voice", "pirate"));

        UserMessage userMessage = new UserMessage("Generate the names of 5 famous pirates.");

        Prompt prompt = new Prompt(List.of(userMessage, systemMessage));
        ChatResponse response = this.chatModel.call(prompt);
        assertThat(response.getResult().getOutput().getContent()).contains("Blackbeard");

    }

    @SpringBootConfiguration
    public static class TestConfiguration {

        @Bean
        public OpenAIClientBuilder openAIClientBuilder() {
            return new OpenAIClientBuilder().credential(new AzureKeyCredential(System.getenv("AZURE_OPENAI_API_KEY")))
                                            .endpoint(System.getenv("AZURE_OPENAI_ENDPOINT"))
                                            .serviceVersion(OpenAIServiceVersion.V2024_02_15_PREVIEW)
                                            .httpLogOptions(new HttpLogOptions()
                                                                    .setLogLevel(com.azure.core.http.policy.HttpLogDetailLevel.BODY_AND_HEADERS));
        }

        @Bean
        public AzureOpenAiChatModel azureOpenAiChatModel(OpenAIClientBuilder openAIClientBuilder) {
            return new AzureOpenAiChatModel(openAIClientBuilder,
                                            AzureOpenAiChatOptions.builder()
                                                                  .withDeploymentName("gpt-4o")
                                                                  .withMaxTokens(1000)
                                                                  .build());

        }

    }
}
```

## Function Calling 

You can register custom Java functions with the AzureOpenAiChatModel and have the OpenAI model intelligently choose to output a JSON object containing arguments to call one or many of the registered functions. This allows you to connect the LLM capabilities with external tools and APIs. The OpenAI models are trained to detect when a function should be called and to respond with JSON that adheres to the function signature.

Here is the sample java code snippet. 

```java
public class MockWeatherService implements Function<Request, Response> {

	public enum Unit { C, F }
	public record Request(String location, Unit unit) {}
	public record Response(double temp, Unit unit) {}

	public Response apply(Request request) {
		return new Response(30.0, Unit.C);
	}
}

@Configuration
static class Config {

    @Bean
    @Description("Get the weather in location") // function description
    public Function<MockWeatherService.Request, MockWeatherService.Response> currentWeather() {
        return new MockWeatherService();
    }

}
```

