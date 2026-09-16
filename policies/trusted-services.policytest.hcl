# Copyright IBM Corp. 2026

policytest {
  targets = ["trusted-services.policy.hcl"]
}

resource "azurerm_storage_account" "pass_inline_azure_services" {
  attrs = {
    id                            = "/subscriptions/test/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/passinline"
    name                          = "passinline"
    resource_group_name           = "rg"
    location                      = "eastus"
    account_tier                  = "Standard"
    account_replication_type      = "LRS"
    public_network_access_enabled = true
    network_rules = {
      default_action = "Deny"
      bypass         = ["AzureServices"]
    }
  }
}

resource "azurerm_storage_account" "pass_inline_list_shape_azure_services" {
  attrs = {
    id                            = "/subscriptions/test/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/passinlinelist"
    name                          = "passinlinelist"
    resource_group_name           = "rg"
    location                      = "eastus"
    account_tier                  = "Standard"
    account_replication_type      = "LRS"
    public_network_access_enabled = true
    network_rules = [{
      default_action = "Deny"
      bypass         = ["AzureServices"]
    }]
  }
}

resource "azurerm_storage_account" "fail_inline_list_shape_without_azure_services" {
  expect_failure = true
  attrs = {
    id                            = "/subscriptions/test/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/faillistshape"
    name                          = "faillistshape"
    resource_group_name           = "rg"
    location                      = "eastus"
    account_tier                  = "Standard"
    account_replication_type      = "LRS"
    public_network_access_enabled = true
    network_rules = [{
      default_action = "Deny"
      bypass         = ["Logging", "Metrics"]
    }]
  }
}

resource "azurerm_storage_account" "fail_inline_bypass_empty" {
  expect_failure = true
  attrs = {
    id                            = "/subscriptions/test/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/failinlineempty"
    name                          = "failinlineempty"
    resource_group_name           = "rg"
    location                      = "eastus"
    account_tier                  = "Standard"
    account_replication_type      = "LRS"
    public_network_access_enabled = true
    network_rules = {
      default_action = "Deny"
      bypass         = [] 
    }
  }
}

resource "azurerm_storage_account" "fail_inline_bypass_null" {
  expect_failure = true
  attrs = {
    id                            = "/subscriptions/test/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/failinlinenull"
    name                          = "failinlinenull"
    resource_group_name           = "rg"
    location                      = "eastus"
    account_tier                  = "Standard"
    account_replication_type      = "LRS"
    public_network_access_enabled = true
    network_rules = {
      default_action = "Deny"
      bypass         = null
    }
  }
}

resource "azurerm_storage_account" "pass_standalone_azure_services" {
  attrs = {
    id                            = "/subscriptions/test/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/passstandalone"
    name                          = "passstandalone"
    resource_group_name           = "rg"
    location                      = "eastus"
    account_tier                  = "Standard"
    account_replication_type      = "LRS"
    public_network_access_enabled = true
  }
}

resource "azurerm_storage_account_network_rules" "pass_standalone_azure_services" {
  skip = true
  attrs = {
    storage_account_id = "/subscriptions/test/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/passstandalone"
    default_action     = "Deny"
    bypass             = ["AzureServices"]
  }
}

resource "azurerm_storage_account" "fail_standalone_without_azure_services" {
  expect_failure = true
  attrs = {
    id                            = "/subscriptions/test/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/failstandalonevalues"
    name                          = "failstandalonevalues"
    resource_group_name           = "rg"
    location                      = "eastus"
    account_tier                  = "Standard"
    account_replication_type      = "LRS"
    public_network_access_enabled = true
  }
}

resource "azurerm_storage_account_network_rules" "fail_standalone_without_azure_services" {
  skip = true
  attrs = {
    storage_account_id = "/subscriptions/test/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/failstandalonevalues"
    default_action     = "Deny"
    bypass             = ["Logging", "Metrics"]
  }
}

resource "azurerm_storage_account" "fail_standalone_multiple_matches" {
  expect_failure = true
  attrs = {
    id                            = "/subscriptions/test/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/failmultimatch"
    name                          = "failmultimatch"
    resource_group_name           = "rg"
    location                      = "eastus"
    account_tier                  = "Standard"
    account_replication_type      = "LRS"
    public_network_access_enabled = true
  }
}

resource "azurerm_storage_account_network_rules" "fail_standalone_multiple_matches_compliant" {
  skip = true
  attrs = {
    storage_account_id = "/subscriptions/test/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/failmultimatch"
    default_action     = "Deny"
    bypass             = ["AzureServices"]
  }
}

resource "azurerm_storage_account_network_rules" "fail_standalone_multiple_matches_noncompliant" {
  skip = true
  attrs = {
    storage_account_id = "/subscriptions/test/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/failmultimatch"
    default_action     = "Deny"
    bypass             = ["Logging"]
  }
}

resource "azurerm_storage_account" "pass_inline_and_standalone_both_present" {
  attrs = {
    id                            = "/subscriptions/test/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/passcombined"
    name                          = "passcombined"
    resource_group_name           = "rg"
    location                      = "eastus"
    account_tier                  = "Standard"
    account_replication_type      = "LRS"
    public_network_access_enabled = true
    network_rules = {
      default_action = "Deny"
      bypass         = ["AzureServices"]
    }
  }
}

resource "azurerm_storage_account_network_rules" "pass_inline_and_standalone_both_present" {
  skip = true
  attrs = {
    storage_account_id = "/subscriptions/test/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/passcombined"
    default_action     = "Deny"
    bypass             = ["AzureServices"]
  }
}

resource "azurerm_storage_account" "pass_public_access_disabled" {
  attrs = {
    id                            = "/subscriptions/test/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/passdisabled"
    name                          = "passdisabled"
    resource_group_name           = "rg"
    location                      = "eastus"
    account_tier                  = "Standard"
    account_replication_type      = "LRS"
    public_network_access_enabled = false
    network_rules = {
      default_action = "Deny"
    }
  }
}

resource "azurerm_storage_account" "pass_default_action_allow" {
  attrs = {
    id                            = "/subscriptions/test/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/passallow"
    name                          = "passallow"
    resource_group_name           = "rg"
    location                      = "eastus"
    account_tier                  = "Standard"
    account_replication_type      = "LRS"
    public_network_access_enabled = true
    network_rules = {
      default_action = "Allow"
    }
  }
}

resource "azurerm_storage_account" "pass_no_network_rules" {
  attrs = {
    id                            = "/subscriptions/test/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/passnorules"
    name                          = "passnorules"
    resource_group_name           = "rg"
    location                      = "eastus"
    account_tier                  = "Standard"
    account_replication_type      = "LRS"
    public_network_access_enabled = true
  }
}
