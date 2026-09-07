# Copyright IBM Corp. 2026

policytest {
  targets = ["disable-shared-key.policy.hcl"]
}

resource "azurerm_storage_account" "pass_shared_key_disabled" {
  attrs = {
    name                      = "passstorageaccount"
    resource_group_name       = "validation-resource-group"
    location                  = "eastus"
    account_tier              = "Standard"
    account_replication_type  = "LRS"
    shared_access_key_enabled = false
  }
}

resource "azurerm_storage_account" "fail_shared_key_enabled" {
  expect_failure = true
  attrs = {
    name                      = "failenabledaccount"
    resource_group_name       = "validation-resource-group"
    location                  = "eastus"
    account_tier              = "Standard"
    account_replication_type  = "LRS"
    shared_access_key_enabled = true
  }
}

resource "azurerm_storage_account" "fail_shared_key_omitted" {
  expect_failure = true
  attrs = {
    name                     = "failomittedaccount"
    resource_group_name      = "validation-resource-group"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

resource "azurerm_storage_account" "fail_shared_key_null" {
  expect_failure = true
  attrs = {
    name                      = "failnullaccount"
    resource_group_name       = "validation-resource-group"
    location                  = "eastus"
    account_tier              = "Standard"
    account_replication_type  = "LRS"
    shared_access_key_enabled = null
  }
}
