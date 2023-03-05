data "azurerm_function_app_host_keys" "linkedin-profile" {
  name                = module.linkedin-profile.name
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_api_management_backend" "linkedin-profile-backend" {
  name                = "linkedin-profile-backend"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.api4fun.name
  protocol            = "http"
  url                 = "https://${module.linkedin-profile.name}.azurewebsites.net/api/"

  credentials {
    header = {
      "x-functions-key" = data.azurerm_function_app_host_keys.linkedin-profile.default_function_key
    }
  }
}

resource "azurerm_api_management_api" "linkedin-api" {
  name                = "linkedin-api"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.api4fun.name
  revision            = "1"
  display_name        = "Linkedin API"
  path                = "linkedin"
  protocols           = ["https"]
  subscription_required = false

  import {
    content_format = "openapi"
    content_value  = file("${path.module}/linkedin-openapi.yaml")
  }
}

resource "azurerm_api_management_api_operation_policy" "getprofile_policy" {
  api_name            = azurerm_api_management_api.linkedin-api.name
  api_management_name = azurerm_api_management.api4fun.name
  resource_group_name = azurerm_resource_group.rg.name
  operation_id        = "getprofile"

  xml_content = <<XML
<policies>
    <inbound>
        <base />
        <mock-response status-code="200" content-type="application/json" />
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
XML
}

resource "azurerm_api_management_api_operation_policy" "getname_policy" {
  api_name            = azurerm_api_management_api.linkedin-api.name
  api_management_name = azurerm_api_management.api4fun.name
  resource_group_name = azurerm_resource_group.rg.name
  operation_id        = "getname"

  xml_content = <<XML
<policies>
    <inbound>
        <base />
        <mock-response status-code="200" content-type="application/json" />
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
XML
}

resource "azurerm_api_management_api_policy" "linkedin-api" {
  api_name            = azurerm_api_management_api.linkedin-api.name
  api_management_name = azurerm_api_management_api.linkedin-api.api_management_name
  resource_group_name = azurerm_api_management_api.linkedin-api.resource_group_name

  xml_content = <<XML
<policies>
    <inbound>
        <base />
        <set-backend-service backend-id="linkedin-profile-backend" />
        <rate-limit-by-key calls="1" renewal-period="60" counter-key="@(context.Subscription?.Key ?? "anonymous")" />
    </inbound>
    <backend>
        <base />
    </backend>
    <outbound>
        <base />
    </outbound>
    <on-error>
        <base />
    </on-error>
</policies>
XML
}

resource "azurerm_api_management_product_api" "linkedin-api-product" {
  api_name            = azurerm_api_management_api.linkedin-api.name
  product_id          = azurerm_api_management_product.basic.product_id
  api_management_name = azurerm_api_management.api4fun.name
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_api_management_product_group" "linkedin-product-group" {
  api_management_name = azurerm_api_management.api4fun.name
  product_id          = azurerm_api_management_product.basic.product_id
  group_name          = data.azurerm_api_management_group.guest.name
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_api_management_product_group" "linkedin-product-group-dev" {
  api_management_name = azurerm_api_management.api4fun.name
  product_id          = azurerm_api_management_product.basic.product_id
  group_name          = data.azurerm_api_management_group.developer.name
  resource_group_name = azurerm_resource_group.rg.name
}
