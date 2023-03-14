resource "azurerm_api_management_api" "confluence-api-v1" {
  name                = "confluence-api"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.api4fun.name
  revision            = "1" # revision mechanism not working on terraform
  path                = "confluence"
  protocols           = ["https"]
  subscription_required = false
  display_name = "Confluence API"

  import {
    content_format = "openapi"
    content_value  = file("${path.module}/confluence-openapi.yaml")
  }
}

resource "azurerm_api_management_api_policy" "confluence-api-base-policy-v1" {
  api_name            = azurerm_api_management_api.confluence-api-v1.name
  api_management_name = azurerm_api_management_api.confluence-api-v1.api_management_name
  resource_group_name = azurerm_api_management_api.confluence-api-v1.resource_group_name

  depends_on = [
    azurerm_api_management_api.confluence-api-v1,
    azurerm_api_management_backend.confluence-backend
  ]

  xml_content = <<-XML
    <policies>
        <inbound>
            <base />
            <set-backend-service backend-id="${azurerm_api_management_backend.confluence-backend.name}" />
        </inbound>
        <backend>
            <base />
        </backend>
        <outbound>
            <base />
            <set-header name="x-aspnet-version" exists-action="delete" />
            <set-header name="x-powered-by" exists-action="delete" />
            <redirect-content-urls />
        </outbound>
        <on-error>
            <base />
        </on-error>
    </policies>
  XML
}

resource "azurerm_api_management_backend" "confluence-backend" {
  name                = "confluence-backend"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.api4fun.name
  protocol            = "http"
  url                 = "https://conferenceapi.azurewebsites.net/"
}
