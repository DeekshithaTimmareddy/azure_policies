policytest {
  targets = ["defender-keyvault-on.policy.hcl"]
}

resource "azurerm_security_center_subscription_pricing" "keyvaults_standard" {
  attrs = {
    resource_type = "KeyVaults"
    tier          = "Standard"
  }
}

resource "azurerm_security_center_subscription_pricing" "keyvaults_free" {
  expect_failure = true
  attrs = {
    resource_type = "KeyVaults"
    tier          = "Free"
  }
}

resource "azurerm_security_center_subscription_pricing" "keyvaults_tier_absent" {
  expect_failure = true
  attrs = {
    resource_type = "KeyVaults"
  }
}

resource "azurerm_security_center_subscription_pricing" "vm_free_out_of_scope" {
  attrs = {
    resource_type = "VirtualMachines"
    tier          = "Free"
  }
}

resource "azurerm_security_center_subscription_pricing" "vm_standard_out_of_scope" {
  attrs = {
    resource_type = "VirtualMachines"
    tier          = "Standard"
  }
}
