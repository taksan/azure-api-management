resource "azurerm_linux_function_app" "a-function" {
  name                = var.function_name
  resource_group_name = var.resourcegroup.name
  location            = var.resourcegroup.location

  storage_account_name       = azurerm_storage_account.function_sa.name
  storage_account_access_key = azurerm_storage_account.function_sa.primary_access_key
  service_plan_id            = azurerm_service_plan.order_function_service_plan.id

  site_config {
    application_stack {
      node_version = 16
    }
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = var.runtime,
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.insights.instrumentation_key,
    WEBSITE_MOUNT_ENABLED = 1
    MICROSOFT_PROVIDER_AUTHENTICATION_SECRET = var.auth_settings != null? var.auth_settings.client_secret: null
  }

  lifecycle {
    ignore_changes = [
      site_config[0].application_insights_key,
      app_settings["APPINSIGHTS_INSTRUMENTATIONKEY"],
      app_settings["WEBSITE_RUN_FROM_PACKAGE"]
    ]
  }

  dynamic "auth_settings" {
    for_each = var.auth_settings != null? [var.auth_settings] : []
    content {
      enabled = true
      default_provider = "AzureActiveDirectory"
      issuer = "https://sts.windows.net/${auth_settings.value.tenant_id}/v2.0"
      token_store_enabled = true

      active_directory {
        client_id = auth_settings.value.client_id
        client_secret = auth_settings.value.client_secret
      }
    }
  }
}

resource "azurerm_storage_account" "function_sa" {
  name                     = var.function_storage_account_name
  resource_group_name      = var.resourcegroup.name
  location                 = var.resourcegroup.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "order_function_service_plan" {
  name                = "${var.function_name}-func-service-plan"
  resource_group_name = var.resourcegroup.name
  location            = var.resourcegroup.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_application_insights" "insights" {
  name                = "${var.function_name}-appinsights"
  location            = var.resourcegroup.location
  resource_group_name = var.resourcegroup.name
  application_type    = "Node.JS"
}

resource "azurerm_storage_container" "function_container" {
  name                 = "function-releases"
  storage_account_name = azurerm_storage_account.function_sa.name
}
