policytest {
  targets = ["purge-protection-enabled.policy.hcl"]
}

resource "azurerm_key_vault" "purge_protection_enabled_passes" {
  attrs = {
    name                     = "kv-enabled"
    location                 = "eastus"
    resource_group_name      = "rg-prod"
    sku_name                 = "standard"
    tenant_id                = "00000000-0000-0000-0000-000000000000"
    purge_protection_enabled = true
  }
}

resource "azurerm_key_vault" "purge_protection_disabled_fails" {
  expect_failure = true
  attrs = {
    name                     = "kv-disabled"
    location                 = "eastus"
    resource_group_name      = "rg-prod"
    sku_name                 = "standard"
    tenant_id                = "00000000-0000-0000-0000-000000000000"
    purge_protection_enabled = false
  }
}

resource "azurerm_key_vault" "purge_protection_absent_fails" {
  expect_failure = true
  attrs = {
    name                = "kv-absent"
    location            = "eastus"
    resource_group_name = "rg-prod"
    sku_name            = "standard"
    tenant_id            = "00000000-0000-0000-0000-000000000000"
  }
}

resource "azurerm_key_vault" "purge_protection_null_fails" {
  expect_failure = true
  attrs = {
    name                     = "kv-null"
    location                 = "eastus"
    resource_group_name      = "rg-prod"
    sku_name                 = "standard"
    tenant_id                = "00000000-0000-0000-0000-000000000000"
    purge_protection_enabled = null
  }
}
