# :rocket: 01 - Set Up Your Environment for the Workshop

To ensure a smooth workshop experience, we need to set up your environment correctly. This includes creating an Azure
subscription using the provided Azure pass and preparing your code environment with the necessary tools.

## Redeem Your Azure Pass

Your Azure Pass provides a $100 USD credit for you to use with Azure, enabling you to create various resources as part
of this workshop. Follow these steps to redeem your pass:  


1. Open a new private browser window. This ensures you don't accidentally link the Azure pass to an existing Microsoft Account or work account. Navigate to the [Microsoft Azure Pass](https://www.microsoftazurepass.com/) website and click the "Start" button.

   ![Azure Pass](images/image01.png "Azure Pass")

2. Create a new Azure Account.

   ![Azure Pass](images/image02.png "Azure Pass")
   ![Azure Pass](images/image03.png "Azure Pass")

3. Enter the provided Promo Code.

   ![Azure Pass](images/image04.png "Azure Pass")

Upon successful redemption, you'll have a newly setup Azure subscription.

## Prepare Your Code Environment for the Workshop

To prepare your code environment for the workshop, you need to install the following tools:

1. [JDK 17](https://docs.microsoft.com/java/openjdk/download?WT.mc_id=azurespringcloud-github-judubois#openjdk-17)
2. VSCode, or IntelliJ for GitHub Copilot
3. [Azure CLI version 2.64.0 or higher](https://docs.microsoft.com/cli/azure/install-azure-cli?view=azure-cli-latest).
   You can check the version of your current Azure CLI installation by running:

    ```bash
    az --version
    ```

4. [Azure Developer CLI](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/install-azd?tabs=winget-windows%2Cbrew-mac%2Cscript-linux&pivots=os-windows)

## Log In with Azure CLI

Signing In with Azure CLI Login to Azure from the CLI with the following command, and complete the prompts to
authenticate:

```bash
az login
```

Next, install or update the necessary Azure CLI extensions for our labs

```bash
az extension add --name containerapp --upgrade --allow-preview true
az extension add --name serviceconnector-passwordless --upgrade --allow-preview true
```

Azure resource providers is to enable functionality for a specific Azure service. Some resource providers are
registered by default. For a list of resource providers registered by default, see Resource providers
for [Azure services](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-services-resource-providers).

Let's register the required Azure resource providers for our labs:

```bash
az config set extension.use_dynamic_install=yes_without_prompt
az provider register --namespace Microsoft.App
az provider register --namespace Microsoft.OperationalInsights
az provider register --namespace Microsoft.ServiceLinker
```

## Prepare Your Azure Environment

This workshop provides Bicep templates to deploy the necessary resources to Azure. To deploy these resources, you need to run the command below from HOME directory:

```bash
azd up
```

This will create resources in your Azure subscription, including:
1. Resource Group
2. Log Analytics workspace
3. Azure OpenAI Endpoint
4. Azure Container Apps Environment
5. Azure Database for MySQL Flexible Server

`azd up` will return the name of resources created in your Azure subscription. Please go to [Azure Portal](https://portal.azure.com) to verify the resources in the resource gorup `aca-labs`

## Configure default settings for Azure Container Apps

> [!IMPORTANT] To ensure easy access to Azure Container Apps, set your default settings:
> ```bash
> az configure --defaults location=koreacentral group=aca-labs
> ```

---

➡️
Up Next : [02 - Create a Hello World Spring Boot App and Deploy to Azure Container Apps](../02-deploy-helloworld/README.md)