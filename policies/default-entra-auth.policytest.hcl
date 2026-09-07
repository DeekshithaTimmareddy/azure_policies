# Copyright IBM Corp. 2026

policytest {
  targets = ["default-entra-auth.policy.hcl"]
}

resource "azurerm_storage_account" "entra_authorization_enabled" {
  attrs = {
    name                            = "passstorageaccount"
    resource_group_name             = "validation-resource-group"
    location                        = "eastus"
    account_tier                    = "Standard"
    account_replication_type        = "LRS"
    default_to_oauth_authentication = true
  }
}

resource "azurerm_storage_account" "entra_authorization_disabled" {
  expect_failure = true
  attrs = {
    name                            = "faildisabledstorage"
    resource_group_name             = "validation-resource-group"
    location                        = "eastus"
    account_tier                    = "Standard"
    account_replication_type        = "LRS"
    default_to_oauth_authentication = false
  }
}

# Omission must fail because the provider defaults this setting to false.
resource "azurerm_storage_account" "entra_authorization_omitted" {
  expect_failure = true
  attrs = {
    name                     = "failomittedstorage"
    resource_group_name      = "validation-resource-group"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

# Explicit null follows a distinct path from omission and is normalized to false.
resource "azurerm_storage_account" "entra_authorization_null" {
  expect_failure = true
  attrs = {
    name                            = "failnullstorageacct"
    resource_group_name             = "validation-resource-group"
    location                        = "eastus"
    account_tier                    = "Standard"
    account_replication_type        = "LRS"
    default_to_oauth_authentication = null
  }
}
