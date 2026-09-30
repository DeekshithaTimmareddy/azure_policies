# Copyright IBM Corp. 2026

policytest {
  targets = ["defender-open-source-relational-databases-on.policy.hcl"]
}

resource "azurerm_security_center_subscription_pricing" "osrdb_standard_passes" {
  attrs = {
    resource_type = "OpenSourceRelationalDatabases"
    tier          = "Standard"
  }
}

resource "azurerm_security_center_subscription_pricing" "osrdb_free_fails" {
  expect_failure = true
  attrs = {
    resource_type = "OpenSourceRelationalDatabases"
    tier          = "Free"
  }
}

resource "azurerm_security_center_subscription_pricing" "osrdb_empty_tier_fails" {
  expect_failure = true
  attrs = {
    resource_type = "OpenSourceRelationalDatabases"
    tier          = ""
  }
}

resource "azurerm_security_center_subscription_pricing" "osrdb_absent_tier_fails" {
  expect_failure = true
  attrs = {
    resource_type = "OpenSourceRelationalDatabases"
  }
}

resource "azurerm_security_center_subscription_pricing" "osrdb_null_tier_fails" {
  expect_failure = true
  attrs = {
    resource_type = "OpenSourceRelationalDatabases"
    tier          = null
  }
}

resource "azurerm_security_center_subscription_pricing" "osrdb_case_insensitive_passes" {
  attrs = {
    resource_type = "opensourceRelationalDatabases"
    tier          = "STANDARD"
  }
}

resource "azurerm_security_center_subscription_pricing" "other_type_free_passes" {
  attrs = {
    resource_type = "VirtualMachines"
    tier          = "Free"
  }
}

resource "azurerm_security_center_subscription_pricing" "other_type_standard_passes" {
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

resource "azurerm_security_center_subscription_pricing" "resource_type_null_out_of_scope" {
  attrs = {
    resource_type = null
    tier          = "Free"
  }
}
