# Copyright IBM Corp. 2026

policytest {
  targets = ["blob-versioning.policy.hcl"]
}

resource "azurerm_storage_account" "pass_versioning_enabled" {
  attrs = {
    name                     = "passversioningacct"
    resource_group_name      = "validation-resource-group"
    location                 = "West Europe"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    account_kind             = "StorageV2"
    blob_properties = {
      versioning_enabled = true
    }
  }
}

resource "azurerm_storage_account" "pass_storage_v1_outside_scope" {
  attrs = {
    name                     = "passstoragev1acct"
    resource_group_name      = "validation-resource-group"
    location                 = "West Europe"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    account_kind             = "Storage"
  }
}

resource "azurerm_storage_account" "pass_file_storage_outside_scope" {
  attrs = {
    name                     = "passfilestorageacct"
    resource_group_name      = "validation-resource-group"
    location                 = "West Europe"
    account_tier             = "Premium"
    account_replication_type = "LRS"
    account_kind             = "FileStorage"
  }
}

resource "azurerm_storage_account" "pass_blob_properties_list_form" {
  attrs = {
    name                     = "passlistformacct"
    resource_group_name      = "validation-resource-group"
    location                 = "West Europe"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    account_kind             = "StorageV2"
    blob_properties = [
      {
        versioning_enabled = true
      }
    ]
  }
}

resource "azurerm_storage_account" "fail_versioning_disabled" {
  expect_failure = true
  attrs = {
    name                     = "failversioningacct"
    resource_group_name      = "validation-resource-group"
    location                 = "West Europe"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    account_kind             = "StorageV2"
    blob_properties = {
      versioning_enabled = false
    }
  }
}

resource "azurerm_storage_account" "fail_blob_properties_missing" {
  expect_failure = true
  attrs = {
    name                     = "failmissingblobacct"
    resource_group_name      = "validation-resource-group"
    location                 = "West Europe"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    account_kind             = "StorageV2"
  }
}

resource "azurerm_storage_account" "fail_versioning_omitted" {
  expect_failure = true
  attrs = {
    name                     = "failomittedversionacct"
    resource_group_name      = "validation-resource-group"
    location                 = "West Europe"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    account_kind             = "StorageV2"
    blob_properties          = {}
  }
}

resource "azurerm_storage_account" "fail_versioning_null" {
  expect_failure = true
  attrs = {
    name                     = "failnullversionacct"
    resource_group_name      = "validation-resource-group"
    location                 = "West Europe"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    account_kind             = "StorageV2"
    blob_properties = {
      versioning_enabled = null
    }
  }
}
