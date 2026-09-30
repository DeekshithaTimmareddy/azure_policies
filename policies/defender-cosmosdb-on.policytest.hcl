# Copyright IBM Corp. 2026

policytest {
  targets = ["defender-cosmosdb-on.policy.hcl"]
}

resource "azurerm_security_center_subscription_pricing" "cosmosdbs_standard_passes" {
  attrs = {
    resource_type = "CosmosDbs"
    tier          = "Standard"
  }
}

resource "azurerm_security_center_subscription_pricing" "cosmosdbs_free_fails" {
  expect_failure = true
  attrs = {
    resource_type = "CosmosDbs"
    tier          = "Free"
  }
}

resource "azurerm_security_center_subscription_pricing" "cosmosdbs_tier_absent_fails" {
  expect_failure = true
  attrs = {
    resource_type = "CosmosDbs"
  }
}

resource "azurerm_security_center_subscription_pricing" "cosmosdbs_tier_null_fails" {
  expect_failure = true
  attrs = {
    resource_type = "CosmosDbs"
    tier          = null
  }
}

resource "azurerm_security_center_subscription_pricing" "virtualmachines_free_out_of_scope" {
  attrs = {
    resource_type = "VirtualMachines"
    tier          = "Free"
  }
}

resource "azurerm_security_center_subscription_pricing" "virtualmachines_standard_out_of_scope" {
  attrs = {
    resource_type = "VirtualMachines"
    tier          = "Standard"
  }
}

resource "azurerm_security_center_subscription_pricing" "resource_type_absent_out_of_scope" {
  attrs = {
    tier = "Free"
  }
}
