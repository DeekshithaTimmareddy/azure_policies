policytest {
  targets = ["defender-sql-databases-on.policy.hcl"]
}

resource "azurerm_security_center_subscription_pricing" "sqlservers_standard" {
  attrs = {
    resource_type = "SqlServers"
    tier          = "Standard"
  }
}

resource "azurerm_security_center_subscription_pricing" "sqlservers_free" {
  expect_failure = true
  attrs = {
    resource_type = "SqlServers"
    tier          = "Free"
  }
}

resource "azurerm_security_center_subscription_pricing" "sqlservers_tier_absent" {
  expect_failure = true
  attrs = {
    resource_type = "SqlServers"
  }
}

resource "azurerm_security_center_subscription_pricing" "sqlservers_tier_null" {
  expect_failure = true
  attrs = {
    resource_type = "SqlServers"
    tier          = null
  }
}

resource "azurerm_security_center_subscription_pricing" "sqlservers_tier_empty" {
  expect_failure = true
  attrs = {
    resource_type = "SqlServers"
    tier          = ""
  }
}

resource "azurerm_security_center_subscription_pricing" "vm_free_out_of_scope" {
  attrs = {
    resource_type = "VirtualMachines"
    tier          = "Free"
  }
}

resource "azurerm_security_center_subscription_pricing" "sqlvm_free_out_of_scope" {
  attrs = {
    resource_type = "SqlServerVirtualMachines"
    tier          = "Free"
  }
}

resource "azurerm_security_center_subscription_pricing" "resource_type_absent" {
  attrs = {
    tier = "Free"
  }
}
