# 01 - Set Up Your Environment for the Workshop

## Redeem Your Azure Pass

You can redeem the Azure Pass to create a subscription in Azure, which will allow you to create resources in Azure. The
provided promo code will give you a $100 USD credit to use  in Azure.

1. Open a private browser window to ensure you do not accidentally use your existing Microsoft Account or work account.
   Navigate to [Microsoft Azure Pass](https://www.microsoftazurepass.com/) and click on the "Start" button.

   ![Azure Pass](images/image01.png "Azure Pass")

2. Create a New Account.

   ![Azure Pass](images/image02.png "Azure Pass")
   ![Azure Pass](images/image03.png "Azure Pass")

3. Enter the Promo Code.

   ![Azure Pass](images/image04.png "Azure Pass")

After filling out the details, it will set up a new Azure subscription for you.

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

To sign in to Azure from the CLI, run the following command and follow the prompts to complete the authentication
process.

```bash
az login
```

Next, install or update the extensions as it's required for the labs.

```bash
az extension add --name containerapp --upgrade
az extension add --name serviceconnector-passwordless --upgrade
```

An Azure resource provider is to enable functionality for a specific Azure service. Some resource providers are
registered by default. For a list of resource providers registered by default, see Resource providers
for [Azure services](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/azure-services-resource-providers).

Register the required Azure providers.

```bash
az config set extension.use_dynamic_install=yes_without_prompt
az provider register --namespace Microsoft.App
az provider register --namespace Microsoft.OperationalInsights
az provider register --namespace Microsoft.ServiceLinker
```

## Configure default settings for Azure Container Apps

```bash
az configure --defaults location=${LOCATION} group=${RESOURCE_GROUP}
```

---

➡️
Next : [02 - Create a Hello World Spring Boot App and Deploy to Azure Container Apps](../02-deploy-helloworld/README.md)