# Copyright IBM Corp. 2026

policytest {
  targets = ["blob-anonymous-disabled.policy.hcl"]
}

resource "azurerm_storage_account" "pass_explicitly_disabled" {
  attrs = {
    name                            = "explicitlydisabledacct"
    resource_group_name             = "validation-resource-group"
    location                        = "East US"
    account_tier                    = "Standard"
    account_replication_type        = "LRS"
    allow_nested_items_to_be_public = false
  }
}

# Omission uses the provider default of true (azurerm v4) — public access enabled, must fail.
resource "azurerm_storage_account" "fail_omitted_defaults_to_public" {
  expect_failure = true
  attrs = {
    name                     = "omitteddefaultacct"
    resource_group_name      = "validation-resource-group"
    location                 = "East US"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

# Explicit null follows the same provider-default normalization — treated as true, must fail.
resource "azurerm_storage_account" "fail_null_defaults_to_public" {
  expect_failure = true
  attrs = {
    name                            = "nulldefaultacct"
    resource_group_name             = "validation-resource-group"
    location                        = "East US"
    account_tier                    = "Standard"
    account_replication_type        = "LRS"
    allow_nested_items_to_be_public = null
  }
}

# FileStorage accounts do not support blob public access; enforcement is skipped.
resource "azurerm_storage_account" "pass_file_storage_kind" {
  attrs = {
    name                     = "filestoragekindacct"
    resource_group_name      = "validation-resource-group"
    location                 = "East US"
    account_tier             = "Premium"
    account_replication_type = "LRS"
    account_kind             = "FileStorage"
  }
}

# BlockBlobStorage accounts do not support blob public access; enforcement is skipped.
resource "azurerm_storage_account" "pass_block_blob_storage_kind" {
  attrs = {
    name                     = "blockblobkindacct"
    resource_group_name      = "validation-resource-group"
    location                 = "East US"
    account_tier             = "Premium"
    account_replication_type = "LRS"
    account_kind             = "BlockBlobStorage"
  }
}

resource "azurerm_storage_account" "fail_anonymous_access_enabled" {
  expect_failure = true
  attrs = {
    name                            = "anonymousenabledacct"
    resource_group_name             = "validation-resource-group"
    location                        = "East US"
    account_tier                    = "Standard"
    account_replication_type        = "LRS"
    allow_nested_items_to_be_public = true
  }
}
