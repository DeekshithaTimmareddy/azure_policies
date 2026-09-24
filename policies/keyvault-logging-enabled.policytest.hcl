policytest {
  targets = ["keyvault-logging-enabled.policy.hcl"]
}

resource "azurerm_monitor_diagnostic_setting" "pass_audit_alllogs_storage" {
  attrs = {
    name               = "kv-diag-pass-storage"
    target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv-pass-storage"
    storage_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/logacct1"
    enabled_log = [
      { category_group = "audit" },
      { category_group = "allLogs" }
    ]
  }
}

resource "azurerm_monitor_diagnostic_setting" "pass_audit_alllogs_law" {
  attrs = {
    name                       = "kv-diag-pass-law"
    target_resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv-pass-law"
    log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.OperationalInsights/workspaces/law1"
    enabled_log = [
      { category_group = "audit" },
      { category_group = "allLogs" }
    ]
  }
}

resource "azurerm_monitor_diagnostic_setting" "fail_empty_logs" {
  expect_failure = true
  attrs = {
    name               = "kv-diag-fail-empty"
    target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv-fail-empty"
    storage_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/logacct2"
    enabled_log        = []
  }
}

resource "azurerm_monitor_diagnostic_setting" "fail_missing_alllogs" {
  expect_failure = true
  attrs = {
    name               = "kv-diag-fail-missing-alllogs"
    target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv-fail-missing-alllogs"
    storage_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/logacct3"
    enabled_log = [
      { category_group = "audit" }
    ]
  }
}

resource "azurerm_monitor_diagnostic_setting" "fail_no_destination" {
  expect_failure = true
  attrs = {
    name               = "kv-diag-fail-no-dest"
    target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv-fail-no-dest"
    enabled_log = [
      { category_group = "audit" },
      { category_group = "allLogs" }
    ]
  }
}
