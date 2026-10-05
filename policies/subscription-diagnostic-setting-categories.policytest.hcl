# Copyright IBM Corp. 2026

policytest {
  targets = ["subscription-diagnostic-setting-categories.policy.hcl"]
}

resource "azurerm_monitor_diagnostic_setting" "pass_real_plan_shape_four_categories" {
  attrs = {
  name                       = "pass-real-plan-shape-four-categories"
  target_resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000"
  log_analytics_workspace_id = null
  enabled_log                = [
    { category = "Administrative", category_group = "" },
    { category = "Alert", category_group = "" },
    { category = "Policy", category_group = "" },
    { category = "Security", category_group = "" }
  ]
  enabled_metric             = []
  }
}

resource "azurerm_monitor_diagnostic_setting" "pass_all_ten_categories" {
  attrs = {
  name                       = "pass-all-ten-categories"
  target_resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000"
  log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-logs/providers/Microsoft.OperationalInsights/workspaces/law"
  enabled_log                = [
    { category = "Administrative", category_group = "" },
    { category = "Alert", category_group = "" },
    { category = "Policy", category_group = "" },
    { category = "Security", category_group = "" },
    { category = "ServiceHealth", category_group = "" },
    { category = "Recommendation", category_group = "" },
    { category = "Autoscale", category_group = "" },
    { category = "ResourceHealth", category_group = "" }
  ]
  enabled_metric             = []
  }
}

resource "azurerm_monitor_diagnostic_setting" "pass_all_logs_category_group" {
  attrs = {
  name                       = "pass-all-logs-category-group"
  target_resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000"
  log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-logs/providers/Microsoft.OperationalInsights/workspaces/law"
  enabled_log                = [
    { category = "", category_group = "allLogs" }
  ]
  enabled_metric             = []
  }
}

resource "azurerm_monitor_diagnostic_setting" "pass_all_logs_mixed_case" {
  attrs = {
  name                       = "pass-all-logs-mixed-case"
  target_resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000"
  log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-logs/providers/Microsoft.OperationalInsights/workspaces/law"
  enabled_log                = [
    { category = "", category_group = "AllLogs" }
  ]
  enabled_metric             = []
  }
}

resource "azurerm_monitor_diagnostic_setting" "pass_categories_mixed_case_whitespace" {
  attrs = {
  name                       = "pass-categories-mixed-case-whitespace"
  target_resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000"
  log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-logs/providers/Microsoft.OperationalInsights/workspaces/law"
  enabled_log                = [
    { category = "administrative", category_group = "" },
    { category = " ALERT ", category_group = "" },
    { category = "policy", category_group = "" },
    { category = "Security", category_group = "" }
  ]
  enabled_metric             = []
  }
}

resource "azurerm_monitor_diagnostic_setting" "pass_subscription_id_mixed_case_trailing_slash" {
  attrs = {
  name                       = "pass-subscription-id-mixed-case-trailing-slash"
  target_resource_id         = "/Subscriptions/00000000-0000-0000-0000-000000000000/"
  log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-logs/providers/Microsoft.OperationalInsights/workspaces/law"
  enabled_log                = [
    { category = "Administrative", category_group = "" },
    { category = "Alert", category_group = "" },
    { category = "Policy", category_group = "" },
    { category = "Security", category_group = "" }
  ]
  enabled_metric             = []
  }
}

resource "azurerm_monitor_diagnostic_setting" "pass_key_vault_target_out_of_scope" {
  attrs = {
  name                       = "pass-key-vault-target-out-of-scope"
  target_resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-app/providers/Microsoft.KeyVault/vaults/kv1"
  log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-logs/providers/Microsoft.OperationalInsights/workspaces/law"
  enabled_log                = [
    { category = "", category_group = "audit" }
  ]
  enabled_metric             = []
  }
}

resource "azurerm_monitor_diagnostic_setting" "fail_missing_security" {
  attrs = {
  name                       = "fail-missing-security"
  target_resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000"
  log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-logs/providers/Microsoft.OperationalInsights/workspaces/law"
  enabled_log                = [
    { category = "Administrative", category_group = "" },
    { category = "Alert", category_group = "" },
    { category = "Policy", category_group = "" }
  ]
  enabled_metric             = []
  }
  expect_failure = true
}

resource "azurerm_monitor_diagnostic_setting" "fail_missing_administrative" {
  attrs = {
  name                       = "fail-missing-administrative"
  target_resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000"
  log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-logs/providers/Microsoft.OperationalInsights/workspaces/law"
  enabled_log                = [
    { category = "Alert", category_group = "" },
    { category = "Policy", category_group = "" },
    { category = "Security", category_group = "" }
  ]
  enabled_metric             = []
  }
  expect_failure = true
}

resource "azurerm_monitor_diagnostic_setting" "fail_missing_alert" {
  attrs = {
  name                       = "fail-missing-alert"
  target_resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000"
  log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-logs/providers/Microsoft.OperationalInsights/workspaces/law"
  enabled_log                = [
    { category = "Administrative", category_group = "" },
    { category = "Policy", category_group = "" },
    { category = "Security", category_group = "" }
  ]
  enabled_metric             = []
  }
  expect_failure = true
}

resource "azurerm_monitor_diagnostic_setting" "fail_missing_policy" {
  attrs = {
  name                       = "fail-missing-policy"
  target_resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000"
  log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-logs/providers/Microsoft.OperationalInsights/workspaces/law"
  enabled_log                = [
    { category = "Administrative", category_group = "" },
    { category = "Alert", category_group = "" },
    { category = "Security", category_group = "" }
  ]
  enabled_metric             = []
  }
  expect_failure = true
}

resource "azurerm_monitor_diagnostic_setting" "fail_only_other_categories" {
  attrs = {
  name                       = "fail-only-other-categories"
  target_resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000"
  log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-logs/providers/Microsoft.OperationalInsights/workspaces/law"
  enabled_log                = [
    { category = "ServiceHealth", category_group = "" },
    { category = "Recommendation", category_group = "" },
    { category = "Autoscale", category_group = "" },
    { category = "ResourceHealth", category_group = "" }
  ]
  enabled_metric             = []
  }
  expect_failure = true
}

resource "azurerm_monitor_diagnostic_setting" "fail_audit_category_group_only" {
  attrs = {
  name                       = "fail-audit-category-group-only"
  target_resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000"
  log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-logs/providers/Microsoft.OperationalInsights/workspaces/law"
  enabled_log                = [
    { category = "", category_group = "audit" }
  ]
  enabled_metric             = []
  }
  expect_failure = true
}

resource "azurerm_monitor_diagnostic_setting" "fail_enabled_log_null" {
  attrs = {
  name                       = "fail-enabled-log-null"
  target_resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000"
  log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-logs/providers/Microsoft.OperationalInsights/workspaces/law"
  enabled_log                = null
  enabled_metric             = []
  }
  expect_failure = true
}

resource "azurerm_monitor_diagnostic_setting" "fail_enabled_log_empty" {
  attrs = {
  name                       = "fail-enabled-log-empty"
  target_resource_id         = "/subscriptions/00000000-0000-0000-0000-000000000000"
  log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-logs/providers/Microsoft.OperationalInsights/workspaces/law"
  enabled_log                = [

  ]
  enabled_metric             = []
  }
  expect_failure = true
}

resource "azurerm_monitor_diagnostic_setting" "fail_uppercase_subscription_missing_policy" {
  attrs = {
  name                       = "fail-uppercase-subscription-missing-policy"
  target_resource_id         = "/SUBSCRIPTIONS/00000000-0000-0000-0000-000000000000"
  log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-logs/providers/Microsoft.OperationalInsights/workspaces/law"
  enabled_log                = [
    { category = "Administrative", category_group = "" },
    { category = "Alert", category_group = "" },
    { category = "Security", category_group = "" }
  ]
  enabled_metric             = []
  }
  expect_failure = true
}
