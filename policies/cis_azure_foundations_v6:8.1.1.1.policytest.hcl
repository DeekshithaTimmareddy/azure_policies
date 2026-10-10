policytest {
  targets = ["cis_azure_foundations_v6:8.1.1.1.policy.hcl"]
}

resource "azurerm_security_center_subscription_pricing" "pass_cspm_standard" {
  attrs = {
    tier          = "Standard"
    resource_type = "CloudPosture"
  }
}

resource "azurerm_security_center_subscription_pricing" "pass_cspm_standard_with_api_posture_extension" {
  attrs = {
    tier          = "Standard"
    resource_type = "CloudPosture"
    extension     = [{ name = "ApiPosture", additional_extension_properties = null }]
  }
}

resource "azurerm_security_center_subscription_pricing" "fail_cspm_free" {
  expect_failure = true
  attrs = {
    tier          = "Free"
    resource_type = "CloudPosture"
  }
}

resource "azurerm_security_center_subscription_pricing" "fail_cspm_tier_null" {
  expect_failure = true
  attrs = {
    tier          = null
    resource_type = "CloudPosture"
  }
}

resource "azurerm_security_center_subscription_pricing" "pass_vm_free" {
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

resource "azurerm_security_center_subscription_pricing" "pass_storage_standard" {
  attrs = {
    tier          = "Standard"
    resource_type = "StorageAccounts"
  }
}
