# Copyright IBM Corp. 2026

policytest {
  targets = ["storage-secure-transfer.policy.hcl"]
}

resource "azurerm_storage_account" "secure_transfer_enabled" {
  attrs = {
    name                       = "securetransferenabled"
    resource_group_name        = "validation-resource-group"
    location                   = "eastus"
    account_tier               = "Standard"
    account_replication_type   = "LRS"
    https_traffic_only_enabled = true
  }
}

# Omission is compliant because AzureRM defaults this optional setting to true.
resource "azurerm_storage_account" "secure_transfer_omitted" {
  attrs = {
    name                     = "securetransferomitted"
    resource_group_name      = "validation-resource-group"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

# Explicit null follows the same provider-default behavior as omission.
resource "azurerm_storage_account" "secure_transfer_null" {
  attrs = {
    name                       = "securetransfernull"
    resource_group_name        = "validation-resource-group"
    location                   = "eastus"
    account_tier               = "Standard"
    account_replication_type   = "LRS"
    https_traffic_only_enabled = null
  }
}

resource "azurerm_storage_account" "secure_transfer_disabled" {
  expect_failure = true
  attrs = {
    name                       = "securetransferdisabled"
    resource_group_name        = "validation-resource-group"
    location                   = "eastus"
    account_tier               = "Standard"
    account_replication_type   = "LRS"
    https_traffic_only_enabled = false
  }
}
