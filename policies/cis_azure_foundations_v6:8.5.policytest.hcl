policytest {
  targets = ["cis_azure_foundations_v6:8.5.policy.hcl"]
}

resource "azurerm_virtual_network" "pass_ddos_enabled" {
  attrs = {
    name                = "vnet-pass"
    location            = "eastus"
    resource_group_name = "rg-net"
    address_space       = ["10.0.0.0/16"]
    ddos_protection_plan = [{
      enable = true
      id     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/ddosProtectionPlans/ddos-plan-1"
    }]
  }
}

resource "azurerm_virtual_network" "fail_ddos_disabled" {
  expect_failure = true
  attrs = {
    name                = "vnet-disabled"
    location            = "eastus"
    resource_group_name = "rg-net"
    address_space       = ["10.1.0.0/16"]
    ddos_protection_plan = [{
      enable = false
      id     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/ddosProtectionPlans/ddos-plan-1"
    }]
  }
}

resource "azurerm_virtual_network" "fail_ddos_plan_block_absent" {
  expect_failure = true
  attrs = {
    name                = "vnet-absent"
    location            = "eastus"
    resource_group_name = "rg-net"
    address_space       = ["10.2.0.0/16"]
  }
}

resource "azurerm_virtual_network" "fail_ddos_plan_block_empty" {
  expect_failure = true
  attrs = {
    name                 = "vnet-empty"
    location             = "eastus"
    resource_group_name  = "rg-net"
    address_space        = ["10.3.0.0/16"]
    ddos_protection_plan = []
  }
}

resource "azurerm_virtual_network" "fail_enable_null" {
  expect_failure = true
  attrs = {
    name                = "vnet-enable-null"
    location            = "eastus"
    resource_group_name = "rg-net"
    address_space       = ["10.4.0.0/16"]
    ddos_protection_plan = [{
      enable = null
      id     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/ddosProtectionPlans/ddos-plan-1"
    }]
  }
}

resource "azurerm_virtual_network" "fail_plan_id_null" {
  expect_failure = true
  attrs = {
    name                = "vnet-plan-id-null"
    location            = "eastus"
    resource_group_name = "rg-net"
    address_space       = ["10.5.0.0/16"]
    ddos_protection_plan = [{
      enable = true
      id     = null
    }]
  }
}

resource "azurerm_virtual_network" "fail_plan_id_empty" {
  expect_failure = true
  attrs = {
    name                = "vnet-plan-id-empty"
    location            = "eastus"
    resource_group_name = "rg-net"
    address_space       = ["10.6.0.0/16"]
    ddos_protection_plan = [{
      enable = true
      id     = " "
    }]
  }
}

resource "azurerm_virtual_network" "pass_other_vnet_independent" {
  attrs = {
    name                = "vnet-separate"
    location            = "eastus"
    resource_group_name = "rg-net"
    address_space       = ["10.7.0.0/16"]
    ddos_protection_plan = [{
      enable = true
      id     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-net/providers/Microsoft.Network/ddosProtectionPlans/shared-plan"
    }]
  }
}
