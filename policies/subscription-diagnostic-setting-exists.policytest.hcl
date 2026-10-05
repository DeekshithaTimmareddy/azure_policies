# Copyright IBM Corp. 2026

policytest {
  targets = ["subscription-diagnostic-setting-exists.policy.hcl"]
}

resource "azurerm_monitor_diagnostic_setting" "pass_real_plan_shape_workspace_unknown" {
  attrs = {
  name               = "pass-real-plan-shape-workspace-unknown"
  target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000"
  log_analytics_workspace_id = null
  storage_account_id = null
  eventhub_authorization_rule_id = null
  eventhub_name = null
  partner_solution_id = null
  enabled_log        = [
    { category = "Administrative", category_group = "" },
    { category = "Alert", category_group = "" },
    { category = "Policy", category_group = "" },
    { category = "Security", category_group = "" }
  ]
  enabled_metric     = []
  }
}

resource "azurerm_monitor_diagnostic_setting" "pass_workspace_destination" {
  attrs = {
  name               = "pass-workspace-destination"
  target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000"
  log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-logs/providers/Microsoft.OperationalInsights/workspaces/law"
  storage_account_id = null
  eventhub_authorization_rule_id = null
  eventhub_name = null
  partner_solution_id = null
  enabled_log        = [
    { category = "Administrative", category_group = "" },
    { category = "Security", category_group = "" }
  ]
  enabled_metric     = []
  }
}

resource "azurerm_monitor_diagnostic_setting" "pass_storage_destination" {
  attrs = {
  name               = "pass-storage-destination"
  target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000"
  log_analytics_workspace_id = null
  storage_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-logs/providers/Microsoft.Storage/storageAccounts/salogs"
  eventhub_authorization_rule_id = null
  eventhub_name = null
  partner_solution_id = null
  enabled_log        = [
    { category = "Policy", category_group = "" }
  ]
  enabled_metric     = []
  }
}

resource "azurerm_monitor_diagnostic_setting" "pass_eventhub_destination" {
  attrs = {
  name               = "pass-eventhub-destination"
  target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000"
  log_analytics_workspace_id = null
  storage_account_id = null
  eventhub_authorization_rule_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-logs/providers/Microsoft.EventHub/namespaces/ns/authorizationRules/RootManageSharedAccessKey"
  eventhub_name = "activity"
  partner_solution_id = null
  enabled_log        = [
    { category = "Alert", category_group = "" }
  ]
  enabled_metric     = []
  }
}

resource "azurerm_monitor_diagnostic_setting" "pass_partner_destination" {
  attrs = {
  name               = "pass-partner-destination"
  target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000"
  log_analytics_workspace_id = null
  storage_account_id = null
  eventhub_authorization_rule_id = null
  eventhub_name = null
  partner_solution_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-logs/providers/Microsoft.Datadog/monitors/dd"
  enabled_log        = [
    { category = "Administrative", category_group = "" }
  ]
  enabled_metric     = []
  }
}

resource "azurerm_monitor_diagnostic_setting" "pass_category_group_all_logs" {
  attrs = {
  name               = "pass-category-group-all-logs"
  target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000"
  log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-logs/providers/Microsoft.OperationalInsights/workspaces/law"
  storage_account_id = null
  eventhub_authorization_rule_id = null
  eventhub_name = null
  partner_solution_id = null
  enabled_log        = [
    { category = "", category_group = "allLogs" }
  ]
  enabled_metric     = []
  }
}

resource "azurerm_monitor_diagnostic_setting" "pass_subscription_id_mixed_case_trailing_slash" {
  attrs = {
  name               = "pass-subscription-id-mixed-case-trailing-slash"
  target_resource_id = "/Subscriptions/00000000-0000-0000-0000-000000000000/"
  log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-logs/providers/Microsoft.OperationalInsights/workspaces/law"
  storage_account_id = null
  eventhub_authorization_rule_id = null
  eventhub_name = null
  partner_solution_id = null
  enabled_log        = [
    { category = "Security", category_group = "" }
  ]
  enabled_metric     = []
  }
}

resource "azurerm_monitor_diagnostic_setting" "pass_non_subscription_target_metrics_only" {
  attrs = {
  name               = "pass-non-subscription-target-metrics-only"
  target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-app/providers/Microsoft.KeyVault/vaults/kv1"
  log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-logs/providers/Microsoft.OperationalInsights/workspaces/law"
  storage_account_id = null
  eventhub_authorization_rule_id = null
  eventhub_name = null
  partner_solution_id = null
  enabled_log        = []
  enabled_metric     = [{ category = "AllMetrics" }]
  }
}

resource "azurerm_monitor_diagnostic_setting" "pass_resource_group_target_out_of_scope" {
  attrs = {
  name               = "pass-resource-group-target-out-of-scope"
  target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-app"
  log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-logs/providers/Microsoft.OperationalInsights/workspaces/law"
  storage_account_id = null
  eventhub_authorization_rule_id = null
  eventhub_name = null
  partner_solution_id = null
  enabled_log        = []
  enabled_metric     = []
  }
}

resource "azurerm_monitor_diagnostic_setting" "fail_metrics_only" {
  attrs = {
  name               = "fail-metrics-only"
  target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000"
  log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-logs/providers/Microsoft.OperationalInsights/workspaces/law"
  storage_account_id = null
  eventhub_authorization_rule_id = null
  eventhub_name = null
  partner_solution_id = null
  enabled_log        = []
  enabled_metric     = [{ category = "AllMetrics" }]
  }
  expect_failure = true
}

resource "azurerm_monitor_diagnostic_setting" "fail_enabled_log_null" {
  attrs = {
  name               = "fail-enabled-log-null"
  target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000"
  log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-logs/providers/Microsoft.OperationalInsights/workspaces/law"
  storage_account_id = null
  eventhub_authorization_rule_id = null
  eventhub_name = null
  partner_solution_id = null
  enabled_log        = null
  enabled_metric     = null
  }
  expect_failure = true
}

resource "azurerm_monitor_diagnostic_setting" "fail_enabled_log_blank_entries" {
  attrs = {
  name               = "fail-enabled-log-blank-entries"
  target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000"
  log_analytics_workspace_id = null
  storage_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-logs/providers/Microsoft.Storage/storageAccounts/salogs"
  eventhub_authorization_rule_id = null
  eventhub_name = null
  partner_solution_id = null
  enabled_log        = [
    { category = "", category_group = "" },
    { category = " ", category_group = "" }
  ]
  enabled_metric     = []
  }
  expect_failure = true
}

resource "azurerm_monitor_diagnostic_setting" "fail_mixed_case_subscription_no_logs" {
  attrs = {
  name               = "fail-mixed-case-subscription-no-logs"
  target_resource_id = "/SUBSCRIPTIONS/00000000-0000-0000-0000-000000000000/"
  log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-logs/providers/Microsoft.OperationalInsights/workspaces/law"
  storage_account_id = null
  eventhub_authorization_rule_id = null
  eventhub_name = null
  partner_solution_id = null
  enabled_log        = []
  enabled_metric     = [{ category = "AllMetrics" }]
  }
  expect_failure = true
}
