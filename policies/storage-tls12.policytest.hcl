# Copyright IBM Corp. 2026

policytest {
  targets = ["storage-tls12.policy.hcl"]
}

resource "azurerm_storage_account" "pass_tls_1_2" {
  attrs = {
    name                     = "stpasstls12"
    resource_group_name      = "rg-validation"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    min_tls_version          = "TLS1_2"
  }
}

resource "azurerm_storage_account" "fail_tls_1_0" {
  expect_failure = true
  attrs = {
    name                     = "stfailtls10"
    resource_group_name      = "rg-validation"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    min_tls_version          = "TLS1_0"
  }
}

resource "azurerm_storage_account" "pass_missing_min_tls_version" {
  attrs = {
    name                     = "stpassmissingtls"
    resource_group_name      = "rg-validation"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

resource "azurerm_storage_account" "fail_empty_min_tls_version" {
  expect_failure = true
  attrs = {
    name                     = "stfailemptytls"
    resource_group_name      = "rg-validation"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    min_tls_version          = ""
  }
}

resource "azurerm_storage_account" "pass_null_min_tls_version" {
  attrs = {
    name                     = "stpassnulltls"
    resource_group_name      = "rg-validation"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    min_tls_version          = null
  }
}
