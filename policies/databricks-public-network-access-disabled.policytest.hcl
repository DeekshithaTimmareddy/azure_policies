# Copyright IBM Corp. 2026

policytest {
  targets = ["databricks-public-network-access-disabled.policy.hcl"]
}

resource "azurerm_databricks_workspace" "public_access_disabled" {
  attrs = {
    location                      = "eastus"
    name                          = "workspace-disabled"
    resource_group_name           = "rg-databricks"
    sku                           = "premium"
    public_network_access_enabled = false
    network_security_group_rules_required = "NoAzureDatabricksRules"
    custom_parameters = [{
      virtual_network_id  = "/subscriptions/sub-a/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet"
      public_subnet_name  = "public-subnet"
      private_subnet_name = "private-subnet"
    }]
  }
}

resource "azurerm_databricks_workspace" "public_access_disabled_no_azure_service_rules" {
  attrs = {
    location                              = "eastus"
    name                                  = "workspace-disabled-service-rules"
    resource_group_name                   = "rg-databricks"
    sku                                   = "premium"
    public_network_access_enabled         = false
    network_security_group_rules_required = "NoAzureServiceRules"
    custom_parameters = [{
      virtual_network_id  = "/subscriptions/sub-a/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet"
      public_subnet_name  = "public-subnet"
      private_subnet_name = "private-subnet"
    }]
  }
}

resource "azurerm_databricks_workspace" "public_access_enabled" {
  expect_failure = true
  attrs = {
    location                      = "eastus"
    name                          = "workspace-enabled"
    resource_group_name           = "rg-databricks"
    sku                           = "premium"
    public_network_access_enabled = true
  }
}

resource "azurerm_databricks_workspace" "public_access_absent" {
  expect_failure = true
  attrs = {
    location            = "eastus"
    name                = "workspace-absent"
    resource_group_name = "rg-databricks"
    sku                 = "premium"
  }
}

resource "azurerm_databricks_workspace" "public_access_null" {
  expect_failure = true
  attrs = {
    location                      = "eastus"
    name                          = "workspace-null"
    resource_group_name           = "rg-databricks"
    sku                           = "premium"
    public_network_access_enabled = null
  }
}

resource "azurerm_databricks_workspace" "required_nsg_rules_all" {
  expect_failure = true
  attrs = {
    location                              = "eastus"
    name                                  = "workspace-all-rules"
    resource_group_name                   = "rg-databricks"
    sku                                   = "premium"
    public_network_access_enabled         = false
    network_security_group_rules_required = "AllRules"
    custom_parameters = [{
      virtual_network_id  = "/subscriptions/sub-a/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet"
      public_subnet_name  = "public-subnet"
      private_subnet_name = "private-subnet"
    }]
  }
}

resource "azurerm_databricks_workspace" "required_nsg_rules_absent" {
  expect_failure = true
  attrs = {
    location                      = "eastus"
    name                          = "workspace-no-required-rules-setting"
    resource_group_name           = "rg-databricks"
    sku                           = "premium"
    public_network_access_enabled = false
    custom_parameters = [{
      virtual_network_id  = "/subscriptions/sub-a/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet"
      public_subnet_name  = "public-subnet"
      private_subnet_name = "private-subnet"
    }]
  }
}

resource "azurerm_databricks_workspace" "required_nsg_rules_invalid" {
  expect_failure = true
  attrs = {
    location                              = "eastus"
    name                                  = "workspace-invalid-required-rules"
    resource_group_name                   = "rg-databricks"
    sku                                   = "premium"
    public_network_access_enabled         = false
    network_security_group_rules_required = "SomeOtherValue"
    custom_parameters = [{
      virtual_network_id  = "/subscriptions/sub-a/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet"
      public_subnet_name  = "public-subnet"
      private_subnet_name = "private-subnet"
    }]
  }
}

resource "azurerm_databricks_workspace" "customer_vnet_absent" {
  expect_failure = true
  attrs = {
    location                              = "eastus"
    name                                  = "workspace-no-customer-vnet"
    resource_group_name                   = "rg-databricks"
    sku                                   = "premium"
    public_network_access_enabled         = false
    network_security_group_rules_required = "NoAzureDatabricksRules"
  }
}

resource "azurerm_databricks_workspace" "customer_vnet_subnet_missing" {
  expect_failure = true
  attrs = {
    location                              = "eastus"
    name                                  = "workspace-no-private-subnet"
    resource_group_name                   = "rg-databricks"
    sku                                   = "premium"
    public_network_access_enabled         = false
    network_security_group_rules_required = "NoAzureDatabricksRules"
    custom_parameters = [{
      virtual_network_id = "/subscriptions/sub-a/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet"
      public_subnet_name = "public-subnet"
    }]
  }
}
