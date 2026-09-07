# Copyright IBM Corp. 2026

policytest {
  targets = ["cross-tenant-replication.policy.hcl"]
}

resource "azurerm_storage_account" "pass_cross_tenant_replication_disabled" {
  attrs = {
    name                             = "stcrossrepdisabled"
    resource_group_name              = "rg-cross-replication-test"
    location                         = "eastus"
    account_tier                     = "Standard"
    account_replication_type         = "LRS"
    cross_tenant_replication_enabled = false
  }
}

resource "azurerm_storage_account" "pass_cross_tenant_replication_omitted" {
  attrs = {
    name                     = "stcrossrepomitted"
    resource_group_name      = "rg-cross-replication-test"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

resource "azurerm_storage_account" "pass_cross_tenant_replication_null" {
  attrs = {
    name                             = "stcrossrepnull"
    resource_group_name              = "rg-cross-replication-test"
    location                         = "eastus"
    account_tier                     = "Standard"
    account_replication_type         = "LRS"
    cross_tenant_replication_enabled = null
  }
}

resource "azurerm_storage_account" "fail_cross_tenant_replication_enabled" {
  expect_failure = true
  attrs = {
    name                             = "stcrossrepenabled"
    resource_group_name              = "rg-cross-replication-test"
    location                         = "eastus"
    account_tier                     = "Standard"
    account_replication_type         = "LRS"
    cross_tenant_replication_enabled = true
  }
}
