policytest {
  targets = ["cis_azure_foundations_v6:9.1.2.policy.hcl"]
}

resource "azurerm_storage_account" "pass_smb311_only" {
  attrs = {
    name                     = "sa912t00"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    location                 = "eastus"
    resource_group_name      = "rg-test"
    share_properties = [{ smb = [{ versions = ["SMB3.1.1"] }] }]
  }
}

resource "azurerm_storage_account" "fail_share_properties_absent" {
  expect_failure = true
  attrs = {
    name                     = "sa912t01"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    location                 = "eastus"
    resource_group_name      = "rg-test"
  }
}

resource "azurerm_storage_account" "fail_share_properties_empty" {
  expect_failure = true
  attrs = {
    name                     = "sa912t02"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    location                 = "eastus"
    resource_group_name      = "rg-test"
    share_properties = []
  }
}

resource "azurerm_storage_account" "fail_smb_absent" {
  expect_failure = true
  attrs = {
    name                     = "sa912t03"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    location                 = "eastus"
    resource_group_name      = "rg-test"
    share_properties = [{ retention_policy = [{ days = 7 }] }]
  }
}

resource "azurerm_storage_account" "fail_smb_empty" {
  expect_failure = true
  attrs = {
    name                     = "sa912t04"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    location                 = "eastus"
    resource_group_name      = "rg-test"
    share_properties = [{ smb = [] }]
  }
}

resource "azurerm_storage_account" "fail_versions_absent" {
  expect_failure = true
  attrs = {
    name                     = "sa912t05"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    location                 = "eastus"
    resource_group_name      = "rg-test"
    share_properties = [{ smb = [{ multichannel_enabled = false }] }]
  }
}

resource "azurerm_storage_account" "fail_versions_null" {
  expect_failure = true
  attrs = {
    name                     = "sa912t06"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    location                 = "eastus"
    resource_group_name      = "rg-test"
    share_properties = [{ smb = [{ versions = null }] }]
  }
}

resource "azurerm_storage_account" "fail_versions_empty" {
  expect_failure = true
  attrs = {
    name                     = "sa912t07"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    location                 = "eastus"
    resource_group_name      = "rg-test"
    share_properties = [{ smb = [{ versions = [] }] }]
  }
}

resource "azurerm_storage_account" "fail_smb30_and_311" {
  expect_failure = true
  attrs = {
    name                     = "sa912t08"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    location                 = "eastus"
    resource_group_name      = "rg-test"
    share_properties = [{ smb = [{ versions = ["SMB3.0", "SMB3.1.1"] }] }]
  }
}

resource "azurerm_storage_account" "fail_all_versions" {
  expect_failure = true
  attrs = {
    name                     = "sa912t09"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    location                 = "eastus"
    resource_group_name      = "rg-test"
    share_properties = [{ smb = [{ versions = ["SMB2.1", "SMB3.0", "SMB3.1.1"] }] }]
  }
}

resource "azurerm_storage_account" "fail_smb30_only" {
  expect_failure = true
  attrs = {
    name                     = "sa912t10"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    location                 = "eastus"
    resource_group_name      = "rg-test"
    share_properties = [{ smb = [{ versions = ["SMB3.0"] }] }]
  }
}

resource "azurerm_storage_account" "fail_smb21_only" {
  expect_failure = true
  attrs = {
    name                     = "sa912t11"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    location                 = "eastus"
    resource_group_name      = "rg-test"
    share_properties = [{ smb = [{ versions = ["SMB2.1"] }] }]
  }
}
