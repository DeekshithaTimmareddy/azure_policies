# Copyright IBM Corp. 2026

policytest {
  targets = ["databricks-no-public-ip-enabled.policy.hcl"]
}

resource "azurerm_databricks_workspace" "no_public_ip_enabled" {
  attrs = {
    name                = "ws-secure"
    location            = "eastus"
    resource_group_name = "rg-databricks"
    sku                 = "premium"
    custom_parameters = [{
      no_public_ip = true
    }]
  }
}

resource "azurerm_databricks_workspace" "no_public_ip_disabled" {
  expect_failure = true
  attrs = {
    name                = "ws-public"
    location            = "eastus"
    resource_group_name = "rg-databricks"
    sku                 = "premium"
    custom_parameters = [{
      no_public_ip = false
    }]
  }
}

resource "azurerm_databricks_workspace" "no_public_ip_omitted_in_block" {
  attrs = {
    name                = "ws-default-attr"
    location            = "eastus"
    resource_group_name = "rg-databricks"
    sku                 = "premium"
    custom_parameters = [{
      virtual_network_id = "vnet-databricks"
    }]
  }
}

resource "azurerm_databricks_workspace" "custom_parameters_absent" {
  attrs = {
    name                = "ws-no-block"
    location            = "eastus"
    resource_group_name = "rg-databricks"
    sku                 = "standard"
  }
}

resource "azurerm_databricks_workspace" "no_public_ip_null" {
  attrs = {
    name                = "ws-null-attr"
    location            = "eastus"
    resource_group_name = "rg-databricks"
    sku                 = "premium"
    custom_parameters = [{
      no_public_ip = null
    }]
  }
}
