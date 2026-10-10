policytest {
  targets = ["cis_azure_foundations_v6:9.3.11.policy.hcl"]
}

resource "azurerm_storage_account" "pass_grs" {
  attrs = {
    name                     = "passgrs01"
    resource_group_name      = "rg-test"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "GRS"
  }
}

resource "azurerm_storage_account" "pass_ragrs" {
  attrs = {
    name                     = "passragrs01"
    resource_group_name      = "rg-test"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "RAGRS"
  }
}

resource "azurerm_storage_account" "pass_gzrs" {
  attrs = {
    name                     = "passgzrs01"
    resource_group_name      = "rg-test"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "GZRS"
  }
}

resource "azurerm_storage_account" "pass_ragzrs" {
  attrs = {
    name                     = "passragzrs01"
    resource_group_name      = "rg-test"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "RAGZRS"
  }
}

resource "azurerm_storage_account" "fail_lrs" {
  expect_failure = true
  attrs = {
    name                     = "faillrs01"
    resource_group_name      = "rg-test"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

resource "azurerm_storage_account" "fail_zrs" {
  expect_failure = true
  attrs = {
    name                     = "failzrs01"
    resource_group_name      = "rg-test"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "ZRS"
  }
}

resource "azurerm_storage_account" "fail_premium_lrs" {
  expect_failure = true
  attrs = {
    name                     = "failpremiumlrs01"
    resource_group_name      = "rg-test"
    location                 = "eastus"
    account_tier             = "Premium"
    account_replication_type = "LRS"
  }
}
