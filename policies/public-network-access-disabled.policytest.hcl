policytest {
  targets = ["public-network-access-disabled.policy.hcl"]
}

resource "azurerm_key_vault" "public_access_disabled" {
  attrs = {
    name                          = "kv-private"
    location                      = "eastus"
    resource_group_name           = "rg-secure"
    sku_name                      = "standard"
    tenant_id                     = "00000000-0000-0000-0000-000000000000"
    public_network_access_enabled = false
  }
}

resource "azurerm_key_vault" "public_access_enabled" {
  expect_failure = true
  attrs = {
    name                          = "kv-public"
    location                      = "eastus"
    resource_group_name           = "rg-open"
    sku_name                      = "standard"
    tenant_id                     = "00000000-0000-0000-0000-000000000000"
    public_network_access_enabled = true
  }
}

resource "azurerm_key_vault" "public_access_omitted" {
  expect_failure = true
  attrs = {
    name                = "kv-default"
    location            = "eastus"
    resource_group_name = "rg-default"
    sku_name            = "standard"
    tenant_id           = "00000000-0000-0000-0000-000000000000"
  }
}

resource "azurerm_key_vault" "public_access_null" {
  expect_failure = true
  attrs = {
    name                          = "kv-null"
    location                      = "eastus"
    resource_group_name           = "rg-null"
    sku_name                      = "standard"
    tenant_id                     = "00000000-0000-0000-0000-000000000000"
    public_network_access_enabled = null
  }
}
