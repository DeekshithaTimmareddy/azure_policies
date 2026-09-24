policytest {
  targets = ["defender-vm-os-updates.policy.hcl"]
}

resource "azurerm_security_center_subscription_pricing" "vm_standard_pass" {
  attrs = {
    resource_type = "VirtualMachines"
    tier          = "Standard"
  }
}

resource "azurerm_security_center_subscription_pricing" "vm_free_fail" {
  expect_failure = true
  attrs = {
    resource_type = "VirtualMachines"
    tier          = "Free"
  }
}

resource "azurerm_security_center_subscription_pricing" "vm_tier_absent_fail" {
  expect_failure = true
  attrs = {
    resource_type = "VirtualMachines"
  }
}

resource "azurerm_security_center_subscription_pricing" "vm_tier_null_fail" {
  expect_failure = true
  attrs = {
    resource_type = "VirtualMachines"
    tier          = null
  }
}

resource "azurerm_security_center_subscription_pricing" "vm_resource_type_omitted_free_fail" {
  expect_failure = true
  attrs = {
    tier = "Free"
  }
}

resource "azurerm_security_center_subscription_pricing" "sql_standard_pass" {
  attrs = {
    resource_type = "SqlServers"
    tier          = "Standard"
  }
}

resource "azurerm_security_center_subscription_pricing" "sql_free_pass" {
  attrs = {
    resource_type = "SqlServers"
    tier          = "Free"
  }
}
