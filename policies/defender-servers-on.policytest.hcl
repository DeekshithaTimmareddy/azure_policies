policytest {
  targets = ["defender-servers-on.policy.hcl"]
}

resource "azurerm_security_center_subscription_pricing" "vm_standard" {
  attrs = {
    resource_type = "VirtualMachines"
    tier          = "Standard"
  }
}

resource "azurerm_security_center_subscription_pricing" "vm_free" {
  expect_failure = true
  attrs = {
    resource_type = "VirtualMachines"
    tier          = "Free"
  }
}

resource "azurerm_security_center_subscription_pricing" "vm_default_type_free" {
  expect_failure = true
  attrs = {
    tier = "Free"
  }
}

resource "azurerm_security_center_subscription_pricing" "storage_free" {
  attrs = {
    resource_type = "StorageAccounts"
    tier          = "Free"
  }
}

resource "azurerm_security_center_subscription_pricing" "storage_standard" {
  attrs = {
    resource_type = "StorageAccounts"
    tier          = "Standard"
  }
}
