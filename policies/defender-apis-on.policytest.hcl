# Copyright IBM Corp. 2026

policytest {
  targets = ["defender-apis-on.policy.hcl"]
}

resource "azurerm_security_center_subscription_pricing" "api_standard_pass" {
  attrs = {
    resource_type = "Api"
    tier          = "Standard"
  }
}

resource "azurerm_security_center_subscription_pricing" "api_free_fail" {
  expect_failure = true
  attrs = {
    resource_type = "Api"
    tier          = "Free"
  }
}

resource "azurerm_security_center_subscription_pricing" "api_tier_absent_fail" {
  expect_failure = true
  attrs = {
    resource_type = "Api"
  }
}

resource "azurerm_security_center_subscription_pricing" "api_tier_null_fail" {
  expect_failure = true
  attrs = {
    resource_type = "Api"
    tier          = null
  }
}

resource "azurerm_security_center_subscription_pricing" "non_api_free_pass" {
  attrs = {
    resource_type = "VirtualMachines"
    tier          = "Free"
  }
}

resource "azurerm_security_center_subscription_pricing" "non_api_standard_pass" {
  attrs = {
    resource_type = "VirtualMachines"
    tier          = "Standard"
  }
}
