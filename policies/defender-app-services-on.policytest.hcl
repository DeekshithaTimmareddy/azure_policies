# Copyright IBM Corp. 2026

policytest {
  targets = ["defender-app-services-on.policy.hcl"]
}

resource "azurerm_security_center_subscription_pricing" "appservices_standard_pass" {
  attrs = {
    resource_type = "AppServices"
    tier          = "Standard"
  }
}

resource "azurerm_security_center_subscription_pricing" "appservices_free_fail" {
  expect_failure = true
  attrs = {
    resource_type = "AppServices"
    tier          = "Free"
  }
}

resource "azurerm_security_center_subscription_pricing" "appservices_blank_tier_fail" {
  expect_failure = true
  attrs = {
    resource_type = "AppServices"
    tier          = ""
  }
}

resource "azurerm_security_center_subscription_pricing" "appservices_tier_absent_fail" {
  expect_failure = true
  attrs = {
    resource_type = "AppServices"
  }
}

resource "azurerm_security_center_subscription_pricing" "appservices_tier_null_fail" {
  expect_failure = true
  attrs = {
    resource_type = "AppServices"
    tier          = null
  }
}

resource "azurerm_security_center_subscription_pricing" "other_type_free_pass" {
  attrs = {
    resource_type = "VirtualMachines"
    tier          = "Free"
  }
}

resource "azurerm_security_center_subscription_pricing" "other_type_standard_pass" {
  attrs = {
    resource_type = "VirtualMachines"
    tier          = "Standard"
  }
}

resource "azurerm_security_center_subscription_pricing" "resource_type_absent_pass" {
  attrs = {
    tier = "Free"
  }
}
