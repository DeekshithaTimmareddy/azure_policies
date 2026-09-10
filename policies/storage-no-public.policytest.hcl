# Copyright IBM Corp. 2026

policytest {
  targets = ["storage-no-public.policy.hcl"]
}

resource "azurerm_storage_account" "pass_public_network_access_disabled" {
  attrs = {
    name                          = "passstorageacct"
    resource_group_name           = "validation-resource-group"
    location                      = "eastus"
    account_tier                  = "Standard"
    account_replication_type      = "LRS"
    public_network_access_enabled = false
  }
}

resource "azurerm_storage_account" "fail_public_network_access_enabled" {
  expect_failure = true
  attrs = {
    name                          = "failenabledstorage"
    resource_group_name           = "validation-resource-group"
    location                      = "eastus"
    account_tier                  = "Standard"
    account_replication_type      = "LRS"
    public_network_access_enabled = true
  }
}

# Omission is noncompliant because the azurerm v4 provider default is true (enabled).
resource "azurerm_storage_account" "fail_public_network_access_omitted" {
  expect_failure = true
  attrs = {
    name                     = "failomittedstorage"
    resource_group_name      = "validation-resource-group"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

# Explicit null is normalized to true (provider default) and remains noncompliant.
resource "azurerm_storage_account" "fail_public_network_access_null" {
  expect_failure = true
  attrs = {
    name                          = "failnullstorageacct"
    resource_group_name           = "validation-resource-group"
    location                      = "eastus"
    account_tier                  = "Standard"
    account_replication_type      = "LRS"
    public_network_access_enabled = null
  }
}
