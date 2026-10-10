policytest {
  targets = ["cis_azure_foundations_v6:8.1.9.1.policy.hcl"]
}

resource "azurerm_security_center_subscription_pricing" "pass_arm_standard" {
  attrs = {
    tier          = "Standard"
    resource_type = "Arm"
  }
}

resource "azurerm_security_center_subscription_pricing" "pass_arm_lowercase_standard" {
  attrs = {
    tier          = "standard"
    resource_type = "Arm"
  }
}

resource "azurerm_security_center_subscription_pricing" "fail_arm_free" {
  expect_failure = true
  attrs = {
    tier          = "Free"
    resource_type = "Arm"
  }
}

resource "azurerm_security_center_subscription_pricing" "fail_arm_null_tier" {
  expect_failure = true
  attrs = {
    tier          = null
    resource_type = "Arm"
  }
}

resource "azurerm_security_center_subscription_pricing" "pass_other_type_free" {
  attrs = {
    tier          = "Free"
    resource_type = "VirtualMachines"
  }
}

resource "azurerm_security_center_subscription_pricing" "pass_resource_type_default_free" {
  attrs = {
    tier = "Free"
  }
}

resource "azurerm_security_center_subscription_pricing" "pass_resource_type_null_defaults_free" {
  attrs = {
    tier          = "Free"
    resource_type = null
  }
}

resource "azurerm_security_center_subscription_pricing" "pass_arm_standard_with_null_subplan" {
  attrs = {
    tier          = "Standard"
    resource_type = "Arm"
    subplan       = null
  }
}
