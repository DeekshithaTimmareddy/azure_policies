# Copyright IBM Corp. 2026

policytest {
  targets = ["databricks-diagnostic-logging-enabled.policy.hcl"]
}

resource "azurerm_databricks_workspace" "all_categories_to_log_analytics" {
  attrs = {
    id                  = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.Databricks/workspaces/dbw-all-categories"
    name                = "dbw-all-categories"
    location            = "eastus"
    resource_group_name = "rg"
    sku                 = "premium"
  }
}

resource "azurerm_monitor_diagnostic_setting" "all_categories_to_log_analytics" {
  skip = true
  attrs = {
    name                       = "DatabricksLogging"
    target_resource_id         = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.Databricks/workspaces/dbw-all-categories"
    log_analytics_workspace_id = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.OperationalInsights/workspaces/la"
    enabled_log = [
      { category = "accounts" },
      { category = "Filesystem" },
      { category = "clusters" },
      { category = "notebook" },
      { category = "jobs" },
    ]
  }
}

resource "azurerm_databricks_workspace" "all_logs_to_storage" {
  attrs = {
    id                  = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.Databricks/workspaces/dbw-all-logs"
    name                = "dbw-all-logs"
    location            = "eastus"
    resource_group_name = "rg"
    sku                 = "premium"
  }
}

resource "azurerm_monitor_diagnostic_setting" "all_logs_to_storage" {
  skip = true
  attrs = {
    name               = "DatabricksLogging"
    target_resource_id = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.Databricks/workspaces/dbw-all-logs"
    storage_account_id = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/dblogsa"
    enabled_log = [
      { category_group = "allLogs" },
    ]
  }
}

resource "azurerm_databricks_workspace" "all_categories_to_eventhub" {
  attrs = {
    id                  = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.Databricks/workspaces/dbw-all-categories-eh"
    name                = "dbw-all-categories-eh"
    location            = "eastus"
    resource_group_name = "rg"
    sku                 = "premium"
  }
}

resource "azurerm_monitor_diagnostic_setting" "all_categories_to_eventhub" {
  skip = true
  attrs = {
    name                           = "DatabricksLogging"
    target_resource_id             = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.Databricks/workspaces/dbw-all-categories-eh"
    eventhub_authorization_rule_id = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.EventHub/namespaces/dblog/authorizationRules/logs"
    enabled_log = [
      { category = "accounts" },
      { category = "Filesystem" },
      { category = "clusters" },
      { category = "notebook" },
      { category = "jobs" },
    ]
  }
}

resource "azurerm_databricks_workspace" "no_diagnostic_setting" {
  expect_failure = true
  attrs = {
    id                  = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.Databricks/workspaces/dbw-no-setting"
    name                = "dbw-no-setting"
    location            = "eastus"
    resource_group_name = "rg"
    sku                 = "premium"
  }
}

resource "azurerm_databricks_workspace" "only_one_category" {
  expect_failure = true
  attrs = {
    id                  = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.Databricks/workspaces/dbw-one-category"
    name                = "dbw-one-category"
    location            = "eastus"
    resource_group_name = "rg"
    sku                 = "premium"
  }
}

resource "azurerm_monitor_diagnostic_setting" "only_one_category" {
  skip = true
  attrs = {
    name                       = "DatabricksLogging"
    target_resource_id         = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.Databricks/workspaces/dbw-one-category"
    log_analytics_workspace_id = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.OperationalInsights/workspaces/la"
    enabled_log                = [{ category = "clusters" }]
  }
}

resource "azurerm_databricks_workspace" "missing_jobs_category" {
  expect_failure = true
  attrs = {
    id                  = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.Databricks/workspaces/dbw-missing-jobs"
    name                = "dbw-missing-jobs"
    location            = "eastus"
    resource_group_name = "rg"
    sku                 = "premium"
  }
}

resource "azurerm_monitor_diagnostic_setting" "missing_jobs_category" {
  skip = true
  attrs = {
    name                       = "DatabricksLogging"
    target_resource_id         = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.Databricks/workspaces/dbw-missing-jobs"
    log_analytics_workspace_id = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.OperationalInsights/workspaces/la"
    enabled_log = [
      { category = "accounts" },
      { category = "Filesystem" },
      { category = "clusters" },
      { category = "notebook" },
    ]
  }
}

resource "azurerm_databricks_workspace" "no_destination" {
  expect_failure = true
  attrs = {
    id                  = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.Databricks/workspaces/dbw-no-destination"
    name                = "dbw-no-destination"
    location            = "eastus"
    resource_group_name = "rg"
    sku                 = "premium"
  }
}

resource "azurerm_monitor_diagnostic_setting" "no_destination" {
  skip = true
  attrs = {
    name               = "DatabricksLogging"
    target_resource_id = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.Databricks/workspaces/dbw-no-destination"
    enabled_log = [
      { category = "accounts" },
      { category = "Filesystem" },
      { category = "clusters" },
      { category = "notebook" },
      { category = "jobs" },
    ]
  }
}

resource "azurerm_databricks_workspace" "setting_targets_other_workspace" {
  expect_failure = true
  attrs = {
    id                  = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.Databricks/workspaces/dbw-wrong-target"
    name                = "dbw-wrong-target"
    location            = "eastus"
    resource_group_name = "rg"
    sku                 = "premium"
  }
}

resource "azurerm_monitor_diagnostic_setting" "setting_targets_other_workspace" {
  skip = true
  attrs = {
    name                       = "DatabricksLogging"
    target_resource_id         = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.Databricks/workspaces/dbw-someone-else"
    log_analytics_workspace_id = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.OperationalInsights/workspaces/la"
    enabled_log = [
      { category = "accounts" },
      { category = "Filesystem" },
      { category = "clusters" },
      { category = "notebook" },
      { category = "jobs" },
    ]
  }
}

resource "azurerm_databricks_workspace" "categories_split_across_settings" {
  attrs = {
    id                  = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.Databricks/workspaces/dbw-split-settings"
    name                = "dbw-split-settings"
    location            = "eastus"
    resource_group_name = "rg"
    sku                 = "premium"
  }
}

resource "azurerm_monitor_diagnostic_setting" "split_categories_primary" {
  skip = true
  attrs = {
    name                       = "DatabricksLoggingPrimary"
    target_resource_id         = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.Databricks/workspaces/dbw-split-settings"
    log_analytics_workspace_id = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.OperationalInsights/workspaces/la"
    enabled_log = [
      { category = "accounts" },
      { category = "Filesystem" },
      { category = "clusters" },
    ]
  }
}

resource "azurerm_monitor_diagnostic_setting" "split_categories_secondary" {
  skip = true
  attrs = {
    name               = "DatabricksLoggingSecondary"
    target_resource_id = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.Databricks/workspaces/dbw-split-settings"
    storage_account_id = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/dblogsa"
    enabled_log = [
      { category = "notebook" },
      { category = "jobs" },
    ]
  }
}

resource "azurerm_databricks_workspace" "split_categories_without_route" {
  expect_failure = true
  attrs = {
    id                  = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.Databricks/workspaces/dbw-split-no-route"
    name                = "dbw-split-no-route"
    location            = "eastus"
    resource_group_name = "rg"
    sku                 = "premium"
  }
}

resource "azurerm_monitor_diagnostic_setting" "split_unrouted_categories" {
  skip = true
  attrs = {
    name               = "DatabricksLoggingUnrouted"
    target_resource_id = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.Databricks/workspaces/dbw-split-no-route"
    enabled_log = [
      { category = "accounts" },
      { category = "Filesystem" },
      { category = "clusters" },
    ]
  }
}

resource "azurerm_monitor_diagnostic_setting" "split_partial_categories_routed" {
  skip = true
  attrs = {
    name                       = "DatabricksLoggingRouted"
    target_resource_id         = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.Databricks/workspaces/dbw-split-no-route"
    log_analytics_workspace_id = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.OperationalInsights/workspaces/la"
    enabled_log = [
      { category = "notebook" },
      { category = "jobs" },
    ]
  }
}

resource "azurerm_databricks_workspace" "standard_sku" {
  expect_failure = true
  attrs = {
    id                  = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.Databricks/workspaces/dbw-standard"
    name                = "dbw-standard"
    location            = "eastus"
    resource_group_name = "rg"
    sku                 = "standard"
  }
}

resource "azurerm_monitor_diagnostic_setting" "standard_sku" {
  skip = true
  attrs = {
    name                       = "DatabricksLogging"
    target_resource_id         = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.Databricks/workspaces/dbw-standard"
    log_analytics_workspace_id = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.OperationalInsights/workspaces/la"
    enabled_log = [
      { category = "accounts" },
      { category = "Filesystem" },
      { category = "clusters" },
      { category = "notebook" },
      { category = "jobs" },
    ]
  }
}

resource "azurerm_databricks_workspace" "whitespace_destination" {
  expect_failure = true
  attrs = {
    id                  = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.Databricks/workspaces/dbw-whitespace-destination"
    name                = "dbw-whitespace-destination"
    location            = "eastus"
    resource_group_name = "rg"
    sku                 = "premium"
  }
}

resource "azurerm_monitor_diagnostic_setting" "whitespace_destination" {
  skip = true
  attrs = {
    name                       = "DatabricksLogging"
    target_resource_id         = "/subscriptions/sub-a/resourceGroups/rg/providers/Microsoft.Databricks/workspaces/dbw-whitespace-destination"
    log_analytics_workspace_id = "   "
    enabled_log = [
      { category = "accounts" },
      { category = "Filesystem" },
      { category = "clusters" },
      { category = "notebook" },
      { category = "jobs" },
    ]
  }
}
