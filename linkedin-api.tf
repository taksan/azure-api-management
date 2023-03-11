locals {
  mock_policy = file("function-policy-mock.xml")
}

resource "azurerm_api_management_api_version_set" "linkedin-api-vs" {
  name                = "linkedin-api-version-set"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.api4fun.name
  display_name        = "LinkedIn"
  versioning_scheme   = "Segment"
}

// API v1
resource "azurerm_api_management_api" "linkedin-api-v1" {
  name                = "linkedin-api"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.api4fun.name
  revision            = "1" # revision mechanism not working on terraform
  display_name        = "Linkedin API"
  path                = "linkedin"
  protocols           = ["https"]
  subscription_required = false
  version_set_id = azurerm_api_management_api_version_set.linkedin-api-vs.id
  version = "v1"

  import {
    content_format = "openapi"
    content_value  = file("${path.module}/linkedin-openapi.yaml")
  }
}

resource "azurerm_api_management_api_policy" "linkedin-api-base-policy-v1" {
  api_name            = azurerm_api_management_api.linkedin-api-v1.name
  api_management_name = azurerm_api_management_api.linkedin-api-v1.api_management_name
  resource_group_name = azurerm_api_management_api.linkedin-api-v1.resource_group_name

  depends_on = [
    azurerm_api_management_backend.linkedin-profile-backend
  ]

  xml_content = templatefile("function-policy-backend.tpl.xml", {
    backend-id = azurerm_api_management_backend.linkedin-profile-backend.name
  })
}

resource "azurerm_api_management_api_operation_policy" "getprofile-v1-policy" {
  api_name            = azurerm_api_management_api.linkedin-api-v1.name
  api_management_name = azurerm_api_management.api4fun.name
  resource_group_name = azurerm_resource_group.rg.name
  operation_id        = "getprofile"

  xml_content = local.mock_policy
}

resource "azurerm_api_management_api_operation_policy" "getname-v1-policy" {
  api_name            = azurerm_api_management_api.linkedin-api-v1.name
  api_management_name = azurerm_api_management.api4fun.name
  resource_group_name = azurerm_resource_group.rg.name
  operation_id        = "getname"

  xml_content = local.mock_policy
}

// v2
resource "azurerm_api_management_api" "linkedin-api-v2" {
  name                = "linkedin-api-v2"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.api4fun.name
  revision            = "1" # revision mechanism not working on terraform
  display_name        = "Linkedin API"
  path                = "linkedin"
  protocols           = ["https"]
  subscription_required = false
  version_set_id = azurerm_api_management_api_version_set.linkedin-api-vs.id
  version = "v2"

  import {
    content_format = "openapi"
    content_value  = file("${path.module}/linkedin-openapi-2.yaml")
  }
}

resource "azurerm_api_management_api_policy" "linkedin-api-base-policy-v2" {
  api_name            = azurerm_api_management_api.linkedin-api-v2.name
  api_management_name = azurerm_api_management_api.linkedin-api-v2.api_management_name
  resource_group_name = azurerm_api_management_api.linkedin-api-v2.resource_group_name

  depends_on = [
    azurerm_api_management_backend.linkedin-profile-backend
  ]

  xml_content = templatefile("function-policy-backend.tpl.xml", {
    backend-id = azurerm_api_management_backend.linkedin-profile-backend.name
  })
}

resource "azurerm_api_management_api_operation_policy" "getname-policy-v2" {
  api_name            = azurerm_api_management_api.linkedin-api-v2.name
  api_management_name = azurerm_api_management.api4fun.name
  resource_group_name = azurerm_resource_group.rg.name
  operation_id        = "getname"

  xml_content = local.mock_policy
}

resource "azurerm_api_management_api_operation_policy" "getprofile-policy-v2" {
  api_name            = azurerm_api_management_api.linkedin-api-v2.name
  api_management_name = azurerm_api_management.api4fun.name
  resource_group_name = azurerm_resource_group.rg.name
  operation_id        = "getprofile"

  xml_content = local.mock_policy
}


// api product
resource "azurerm_api_management_product_api" "linkedin-api-v1-product" {
  api_name            = azurerm_api_management_api.linkedin-api-v1.name
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
