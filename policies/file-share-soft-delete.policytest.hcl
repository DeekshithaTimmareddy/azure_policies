# Copyright IBM Corp. 2026

policytest {
  targets = ["file-share-soft-delete.policy.hcl"]
}

resource "azurerm_storage_account" "pass_minimum_retention" {
  attrs = {
    name                     = "passminimumretention"
    resource_group_name      = "validation-resource-group"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    share_properties = [{
      retention_policy = [{
        days = 1
      }]
    }]
  }
}

resource "azurerm_storage_account" "pass_maximum_retention" {
  attrs = {
    name                     = "passmaximumretention"
    resource_group_name      = "validation-resource-group"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    share_properties = [{
      retention_policy = [{
        days = 365
      }]
    }]
  }
}

# Missing optional share_properties must be treated as a violation, not skipped.
resource "azurerm_storage_account" "fail_missing_share_properties" {
  expect_failure = true
  attrs = {
    name                     = "failmissingshareprops"
    resource_group_name      = "validation-resource-group"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

resource "azurerm_storage_account" "fail_missing_retention_policy" {
  expect_failure = true
  attrs = {
    name                     = "failmissingretention"
    resource_group_name      = "validation-resource-group"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    share_properties         = [{}]
  }
}

resource "azurerm_storage_account" "fail_empty_share_properties" {
  expect_failure = true
  attrs = {
    name                     = "failemptyshareprops"
    resource_group_name      = "validation-resource-group"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    share_properties         = []
  }
}

# Explicit null follows a separate normalization path from an omitted attribute.
resource "azurerm_storage_account" "fail_null_retention_days" {
  expect_failure = true
  attrs = {
    name                     = "failnullretentiondays"
    resource_group_name      = "validation-resource-group"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    share_properties = [{
      retention_policy = [{
        days = null
      }]
    }]
  }
}

resource "azurerm_storage_account" "fail_retention_below_minimum" {
  expect_failure = true
  attrs = {
    name                     = "failretentionbelowmin"
    resource_group_name      = "validation-resource-group"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    share_properties = [{
      retention_policy = [{
        days = 0
      }]
    }]
  }
}

resource "azurerm_storage_account" "fail_retention_above_maximum" {
  expect_failure = true
  attrs = {
    name                     = "failretentionabovemax"
    resource_group_name      = "validation-resource-group"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    share_properties = [{
      retention_policy = [{
        days = 366
      }]
    }]
  }
}

resource "azurerm_storage_account" "pass_unsupported_kind_blob" {
  attrs = {
    name                     = "passunsupportedblob"
    resource_group_name      = "validation-resource-group"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    account_kind             = "BlobStorage"
  }
}

resource "azurerm_storage_account" "pass_unsupported_kind_block_blob" {
  attrs = {
    name                     = "passunsupportedblockblob"
    resource_group_name      = "validation-resource-group"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    account_kind             = "BlockBlobStorage"
  }
}

