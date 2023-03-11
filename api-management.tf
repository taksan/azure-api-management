resource "azurerm_api_management" "api4fun" {
  name                = "api4fun"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  publisher_name      = var.api_publisher_name
  publisher_email     = var.api_publisher_email

  identity {
    type = "SystemAssigned"
  }

  sku_name = "Developer_1"
}

resource "azurerm_application_insights" "appinsights" {
  name                = "tf-appinsights"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
}

resource "azurerm_api_management_logger" "api4fun" {
  name                = "api4fun-apimlogger"
  api_management_name = azurerm_api_management.api4fun.name
  resource_group_name = azurerm_resource_group.rg.name

  application_insights {
    instrumentation_key = azurerm_application_insights.appinsights.instrumentation_key
  }
}

data "azurerm_api_management_product" "starter" {
  product_id          = "starter"
  api_management_name = azurerm_api_management.api4fun.name
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_api_management_product" "basic" {
  display_name          = "Basic"
  product_id            = "basic"
  published             = true
  api_management_name   = azurerm_api_management.api4fun.name
  resource_group_name   = azurerm_resource_group.rg.name
  subscription_required = false
#  approval_required     = true
#  subscriptions_limit   = 1
}

data "azurerm_api_management_group" "guest" {
  name                = "guests"
  api_management_name = azurerm_api_management.api4fun.name
  resource_group_name = azurerm_resource_group.rg.name
}

data "azurerm_api_management_group" "developer" {
  name                = "developers"
  api_management_name = azurerm_api_management.api4fun.name
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_api_management_user" "user" {
  for_each = var.linked_api_users
  user_id             = random_pet.user[each.key].id
  api_management_name = azurerm_api_management.api4fun.name
  resource_group_name = azurerm_resource_group.rg.name
  first_name          = each.value.first_name
  last_name           = each.value.last_name
  email               = each.key
  state               = "active"
  password            = each.value.password
}

resource "random_pet" "user" {
  for_each = var.linked_api_users
}

 resource "azurerm_api_management_diagnostic" "api4fun" {
   identifier               = "applicationinsights"
   resource_group_name      = azurerm_resource_group.rg.name
   api_management_name      = azurerm_api_management.api4fun.name
   api_management_logger_id = azurerm_api_management_logger.api4fun.id

   sampling_percentage       = 5.0
   always_log_errors         = true
   log_client_ip             = true
   verbosity                 = "verbose"
   http_correlation_protocol = "W3C"

   frontend_request {
     body_bytes = 32
     headers_to_log = [
       "content-type",
       "accept",
       "origin",
     ]
   }

   frontend_response {
     body_bytes = 32
     headers_to_log = [
       "content-type",
       "content-length",
       "origin",
     ]
   }

   backend_request {
     body_bytes = 32
     headers_to_log = [
       "content-type",
       "accept",
       "origin",
     ]
   }

   backend_response {
     body_bytes = 32
     headers_to_log = [
       "content-type",
       "content-length",
       "origin",
     ]
   }
 }
