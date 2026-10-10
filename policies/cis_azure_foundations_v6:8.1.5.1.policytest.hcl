policytest {
  targets = ["cis_azure_foundations_v6:8.1.5.1.policy.hcl"]
}

resource "azurerm_security_center_subscription_pricing" "pass_storage_standard" {
  attrs = {
    tier          = "Standard"
    resource_type = "StorageAccounts"
  }
}

resource "azurerm_security_center_subscription_pricing" "pass_storage_standard_with_subplan" {
  attrs = {
    tier          = "Standard"
    resource_type = "StorageAccounts"
    subplan       = "DefenderForStorageV2"
  }
}

resource "azurerm_security_center_subscription_pricing" "pass_storage_lowercase_standard" {
  attrs = {
    tier          = "standard"
    resource_type = "StorageAccounts"
  }
}

resource "azurerm_security_center_subscription_pricing" "fail_storage_free" {
  expect_failure = true
  attrs = {
    tier          = "Free"
    resource_type = "StorageAccounts"
  }
}

resource "azurerm_security_center_subscription_pricing" "fail_storage_free_with_subplan" {
  expect_failure = true
  attrs = {
    tier          = "Free"
    resource_type = "StorageAccounts"
    subplan       = "DefenderForStorageV2"
  }
}

resource "azurerm_security_center_subscription_pricing" "fail_storage_null_tier" {
  expect_failure = true
  attrs = {
    tier          = null
    resource_type = "StorageAccounts"
  }
}

resource "azurerm_security_center_subscription_pricing" "pass_other_plan_free" {
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
