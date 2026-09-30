# Copyright IBM Corp. 2026

policytest {
  targets = ["databricks-vnet-injection.policy.hcl"]
}

resource "azurerm_databricks_workspace" "customer_managed_vnet" {
  attrs = {
    name                = "dbw-vnet-injected"
    location            = "eastus"
    resource_group_name = "rg-databricks"
    sku                 = "premium"
    custom_parameters = [{
      virtual_network_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/virtualNetworks/dbw-vnet"
      public_subnet_name  = "public-subnet"
      private_subnet_name = "private-subnet"
    }]
  }
}

resource "azurerm_databricks_workspace" "public_subnet_absent" {
  expect_failure = true
  attrs = {
    name                = "dbw-no-public-subnet"
    location            = "eastus"
    resource_group_name = "rg-databricks"
    sku                 = "premium"
    custom_parameters = [{
      virtual_network_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/virtualNetworks/dbw-vnet"
      private_subnet_name = "private-subnet"
    }]
  }
}

resource "azurerm_databricks_workspace" "private_subnet_absent" {
  expect_failure = true
  attrs = {
    name                = "dbw-no-private-subnet"
    location            = "eastus"
    resource_group_name = "rg-databricks"
    sku                 = "premium"
    custom_parameters = [{
      virtual_network_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/virtualNetworks/dbw-vnet"
      public_subnet_name = "public-subnet"
    }]
  }
}

resource "azurerm_databricks_workspace" "blank_public_subnet_name" {
  expect_failure = true
  attrs = {
    name                = "dbw-blank-network-values"
    location            = "eastus"
    resource_group_name = "rg-databricks"
    sku                 = "premium"
    custom_parameters = [{
      virtual_network_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/virtualNetworks/dbw-vnet"
      public_subnet_name = "   "
      private_subnet_name = "private-subnet"
    }]
  }
}

resource "azurerm_databricks_workspace" "vnet_id_absent" {
  expect_failure = true
  attrs = {
    name                = "dbw-no-vnetid"
    location            = "eastus"
    resource_group_name = "rg-databricks"
    sku                 = "premium"
    custom_parameters = [{
      no_public_ip = true
    }]
  }
}

resource "azurerm_databricks_workspace" "vnet_id_null" {
  expect_failure = true
  attrs = {
    name                = "dbw-null-vnetid"
    location            = "eastus"
    resource_group_name = "rg-databricks"
    sku                 = "premium"
    custom_parameters = [{
      virtual_network_id = null
    }]
  }
}

resource "azurerm_databricks_workspace" "vnet_id_empty" {
  expect_failure = true
  attrs = {
    name                = "dbw-empty-vnetid"
    location            = "eastus"
    resource_group_name = "rg-databricks"
    sku                 = "premium"
    custom_parameters = [{
      virtual_network_id = ""
    }]
  }
}

resource "azurerm_databricks_workspace" "vnet_id_whitespace_only" {
  expect_failure = true
  attrs = {
    name                = "dbw-whitespace-vnetid"
    location            = "eastus"
    resource_group_name = "rg-databricks"
    sku                 = "premium"
    custom_parameters = [{
      virtual_network_id = "   "
    }]
  }
}

resource "azurerm_databricks_workspace" "no_custom_parameters" {
  expect_failure = true
  attrs = {
    name                = "dbw-managed-default"
    location            = "eastus"
    resource_group_name = "rg-databricks"
    sku                 = "standard"
  }
}

resource "azurerm_databricks_workspace" "custom_parameters_null" {
  expect_failure = true
  attrs = {
    name                = "dbw-null-custom-params"
    location            = "eastus"
    resource_group_name = "rg-databricks"
    sku                 = "premium"
    custom_parameters   = null
  }
}
