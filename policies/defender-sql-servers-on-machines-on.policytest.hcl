policytest {
  targets = ["defender-sql-servers-on-machines-on.policy.hcl"]
}

resource "azurerm_security_center_subscription_pricing" "sql_vm_standard_pass" {
  attrs = {
    resource_type = "SqlServerVirtualMachines"
    tier          = "Standard"
  }
}

resource "azurerm_security_center_subscription_pricing" "sql_vm_free_fail" {
  expect_failure = true
  attrs = {
    resource_type = "SqlServerVirtualMachines"
    tier          = "Free"
  }
}

resource "azurerm_security_center_subscription_pricing" "sql_vm_tier_absent_fail" {
  expect_failure = true
  attrs = {
    resource_type = "SqlServerVirtualMachines"
  }
}

resource "azurerm_security_center_subscription_pricing" "sql_vm_tier_null_fail" {
  expect_failure = true
  attrs = {
    resource_type = "SqlServerVirtualMachines"
    tier          = null
  }
}

resource "azurerm_security_center_subscription_pricing" "sql_vm_tier_empty_fail" {
  expect_failure = true
  attrs = {
    resource_type = "SqlServerVirtualMachines"
    tier          = ""
  }
}

resource "azurerm_security_center_subscription_pricing" "resource_type_absent_pass" {
  attrs = {
    tier = "Free"
  }
}

resource "azurerm_security_center_subscription_pricing" "other_plan_vm_free_pass" {
  attrs = {
    resource_type = "VirtualMachines"
    tier          = "Free"
  }
}

resource "azurerm_security_center_subscription_pricing" "sql_databases_plan_pass" {
  attrs = {
    resource_type = "SqlServers"
    tier          = "Standard"
  }
}
