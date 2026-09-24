policytest {
  targets = ["rbac-enabled.policy.hcl"]
}

resource "azurerm_key_vault" "rbac_enabled_new_attr" {
  attrs = {
    name                       = "kv-rbac-enabled-v5"
    location                   = "eastus"
    resource_group_name        = "rg-security"
    sku_name                   = "standard"
    tenant_id                  = "11111111-1111-1111-1111-111111111111"
    rbac_authorization_enabled = true
  }
}

resource "azurerm_key_vault" "rbac_enabled_legacy_attr" {
  attrs = {
    name                    = "kv-rbac-enabled-legacy"
    location                = "eastus"
    resource_group_name     = "rg-security"
    sku_name                = "standard"
    tenant_id               = "55555555-5555-5555-5555-555555555555"
    enable_rbac_authorization = true
  }
}

resource "azurerm_key_vault" "rbac_disabled" {
  expect_failure = true
  attrs = {
    name                       = "kv-rbac-disabled"
    location                   = "eastus"
    resource_group_name        = "rg-security"
    sku_name                   = "standard"
    tenant_id                  = "22222222-2222-2222-2222-222222222222"
    rbac_authorization_enabled = false
  }
}

resource "azurerm_key_vault" "rbac_disabled_legacy_attr" {
  expect_failure = true
  attrs = {
    name                      = "kv-rbac-disabled-legacy"
    location                  = "eastus"
    resource_group_name       = "rg-security"
    sku_name                  = "standard"
    tenant_id                 = "66666666-6666-6666-6666-666666666666"
    enable_rbac_authorization = false
  }
}

resource "azurerm_key_vault" "rbac_absent" {
  expect_failure = true
  attrs = {
    name                = "kv-rbac-absent"
    location            = "eastus"
    resource_group_name = "rg-security"
    sku_name            = "standard"
    tenant_id           = "33333333-3333-3333-3333-333333333333"
  }
}

resource "azurerm_key_vault" "rbac_null" {
  expect_failure = true
  attrs = {
    name                       = "kv-rbac-null"
    location                   = "eastus"
    resource_group_name        = "rg-security"
    sku_name                   = "standard"
    tenant_id                  = "44444444-4444-4444-4444-444444444444"
    rbac_authorization_enabled = null
  }
}
