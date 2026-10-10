policytest {
  targets = ["cis_azure_foundations_v6:9.3.2.3.policy.hcl"]
}

resource "azurerm_storage_account" "pass_inline_deny" {
  attrs = {
    name = "sapassdeny01"
    id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/sapassdeny01"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    location                 = "eastus"
    resource_group_name      = "rg-test"
    public_network_access_enabled = true
    network_rules = [{ default_action = "Deny", bypass = ["AzureServices"], ip_rules = [], virtual_network_subnet_ids = [] }]
  }
}

resource "azurerm_storage_account" "pass_inline_deny_pna_absent" {
  attrs = {
    name = "sapassdeny02"
    id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/sapassdeny02"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    location                 = "eastus"
    resource_group_name      = "rg-test"
    network_rules = [{ default_action = "Deny", bypass = ["AzureServices"], ip_rules = [], virtual_network_subnet_ids = [] }]
  }
}

resource "azurerm_storage_account" "fail_inline_allow" {
  expect_failure = true
  attrs = {
    name = "safailallow01"
    id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/safailallow01"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    location                 = "eastus"
    resource_group_name      = "rg-test"
    public_network_access_enabled = true
    network_rules = [{ default_action = "Allow", bypass = ["AzureServices"], ip_rules = [], virtual_network_subnet_ids = [] }]
  }
}

resource "azurerm_storage_account" "fail_inline_allow_pna_absent" {
  expect_failure = true
  attrs = {
    name = "safailallow02"
    id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/safailallow02"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    location                 = "eastus"
    resource_group_name      = "rg-test"
    network_rules = [{ default_action = "Allow", bypass = ["AzureServices"], ip_rules = [], virtual_network_subnet_ids = [] }]
  }
}

resource "azurerm_storage_account" "fail_network_rules_absent" {
  expect_failure = true
  attrs = {
    name = "safailabsent01"
    id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/safailabsent01"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    location                 = "eastus"
    resource_group_name      = "rg-test"
    public_network_access_enabled = true
  }
}

resource "azurerm_storage_account" "fail_network_rules_null" {
  expect_failure = true
  attrs = {
    name = "safailnull01"
    id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/safailnull01"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    location                 = "eastus"
    resource_group_name      = "rg-test"
    public_network_access_enabled = true
    network_rules = null
  }
}

resource "azurerm_storage_account" "fail_network_rules_empty" {
  expect_failure = true
  attrs = {
    name = "safailempty01"
    id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/safailempty01"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    location                 = "eastus"
    resource_group_name      = "rg-test"
    public_network_access_enabled = true
    network_rules = []
  }
}

resource "azurerm_storage_account" "pass_public_access_disabled" {
  attrs = {
    name = "sapassprivate01"
    id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/sapassprivate01"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    location                 = "eastus"
    resource_group_name      = "rg-test"
    public_network_access_enabled = false
  }
}

resource "azurerm_storage_account" "pass_public_access_disabled_inline_allow" {
  attrs = {
    name = "sapassprivate02"
    id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/sapassprivate02"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    location                 = "eastus"
    resource_group_name      = "rg-test"
    public_network_access_enabled = false
    network_rules = [{ default_action = "Allow", bypass = ["AzureServices"], ip_rules = [], virtual_network_subnet_ids = [] }]
  }
}

resource "azurerm_storage_account" "pass_separate_rules_deny" {
  attrs = {
    name = "sapassseparate01"
    id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/sapassseparate01"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    location                 = "eastus"
    resource_group_name      = "rg-test"
    public_network_access_enabled = true
  }
}

resource "azurerm_storage_account_network_rules" "pass_nr_deny" {
  attrs = {
    storage_account_id = "/SUBSCRIPTIONS/00000000-0000-0000-0000-000000000000/RESOURCEGROUPS/RG-TEST/PROVIDERS/MICROSOFT.STORAGE/STORAGEACCOUNTS/SAPASSSEPARATE01"
    default_action     = "Deny"
  }
}

resource "azurerm_storage_account" "fail_separate_rules_allow" {
  expect_failure = true
  attrs = {
    name = "safailseparate01"
    id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/safailseparate01"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    location                 = "eastus"
    resource_group_name      = "rg-test"
    public_network_access_enabled = true
  }
}

resource "azurerm_storage_account_network_rules" "fail_nr_allow" {
  expect_failure = true
  attrs = {
    storage_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/safailseparate01"
    default_action     = "Allow"
  }
}

resource "azurerm_storage_account" "pass_exempt_separate_allow" {
  attrs = {
    name = "sapassexempt01"
    id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/sapassexempt01"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    location                 = "eastus"
    resource_group_name      = "rg-test"
    public_network_access_enabled = false
  }
}

resource "azurerm_storage_account_network_rules" "pass_nr_allow_exempt_account" {
  attrs = {
    storage_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/sapassexempt01"
    default_action     = "Allow"
  }
}

resource "azurerm_storage_account" "fail_inline_deny_overridden" {
  expect_failure = true
  attrs = {
    name = "safailoverride01"
    id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/safailoverride01"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    location                 = "eastus"
    resource_group_name      = "rg-test"
    public_network_access_enabled = true
    network_rules = [{ default_action = "Deny", bypass = ["AzureServices"], ip_rules = [], virtual_network_subnet_ids = [] }]
  }
}

resource "azurerm_storage_account_network_rules" "fail_nr_allow_overrides_inline_deny" {
  expect_failure = true
  attrs = {
    storage_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Storage/storageAccounts/safailoverride01"
    default_action     = "Allow"
  }
}

resource "azurerm_storage_account" "fail_same_name_other_resource_group" {
  expect_failure = true
  attrs = {
    name = "duplicatename"
    id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.Storage/storageAccounts/duplicatename"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    location                 = "eastus"
    resource_group_name      = "rg1"
    public_network_access_enabled = true
  }
}

resource "azurerm_storage_account_network_rules" "pass_rules_other_resource_group_same_name" {
  attrs = {
    storage_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg2/providers/Microsoft.Storage/storageAccounts/duplicatename"
    default_action     = "Deny"
  }
}

resource "azurerm_storage_account" "pass_disabled_same_name_other_resource_group" {
  attrs = {
    name = "disabledduplicate"
    id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.Storage/storageAccounts/disabledduplicate"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    location                 = "eastus"
    resource_group_name      = "rg1"
    public_network_access_enabled = false
  }
}

resource "azurerm_storage_account_network_rules" "fail_allow_not_exempted_by_same_name_account" {
  expect_failure = true
  attrs = {
    storage_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg2/providers/Microsoft.Storage/storageAccounts/disabledduplicate"
    default_action     = "Allow"
  }
}
