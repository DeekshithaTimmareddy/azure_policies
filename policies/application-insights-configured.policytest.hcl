# Copyright IBM Corp. 2026

policytest {
  targets = ["application-insights-configured.policy.hcl"]
}

resource "azurerm_application_insights" "pass_workspace_web" {
  attrs = {
    application_type = "web"
    workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-monitor/providers/Microsoft.OperationalInsights/workspaces/law-pass"
  }
}

resource "azurerm_application_insights" "pass_workspace_other" {
  attrs = {
    application_type = "other"
    workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-monitor/providers/Microsoft.OperationalInsights/workspaces/law-other"
  }
}

resource "azurerm_application_insights" "pass_workspace_new_in_plan" {
  attrs = {
    application_type = "web"
    name = "appi-new-workspace"
    location = "eastus"
    resource_group_name = "rg-monitor"
  }
}

resource "azurerm_application_insights" "pass_workspace_null_unknown" {
  attrs = {
    application_type = "web"
    workspace_id = null
  }
}

resource "azurerm_application_insights" "pass_workspace_case_and_whitespace" {
  attrs = {
    workspace_id = " /SUBSCRIPTIONS/00000000-0000-0000-0000-000000000000/RESOURCEGROUPS/rg-monitor/PROVIDERS/MICROSOFT.OPERATIONALINSIGHTS/WORKSPACES/law-pass "
  }
}

resource "azurerm_application_insights" "pass_cross_subscription_workspace" {
  attrs = {
    workspace_id = "/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/rg-external/providers/Microsoft.OperationalInsights/workspaces/law-shared"
  }
}

resource "azurerm_application_insights" "pass_no_retention_requirement" {
  attrs = {
    retention_in_days = 30
    sampling_percentage = 50
    workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-monitor/providers/Microsoft.OperationalInsights/workspaces/law-pass"
  }
}

resource "azurerm_log_analytics_workspace" "pass_workspace_out_of_scope" {
  attrs = {
    name = "law-unrelated"
  }
}

resource "azurerm_resource_group" "pass_resource_group_out_of_scope" {
  attrs = {
    name = "rg-unrelated"
  }
}

resource "azurerm_application_insights" "fail_workspace_empty" {
  expect_failure = true
  attrs = {
    workspace_id = ""
  }
}

resource "azurerm_application_insights" "fail_workspace_whitespace" {
  expect_failure = true
  attrs = {
    workspace_id = "   "
  }
}

resource "azurerm_application_insights" "fail_workspace_name_only" {
  expect_failure = true
  attrs = {
    workspace_id = "law-monitor"
  }
}

resource "azurerm_application_insights" "fail_resource_group_id" {
  expect_failure = true
  attrs = {
    workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-monitor"
  }
}

resource "azurerm_application_insights" "fail_wrong_resource_type" {
  expect_failure = true
  attrs = {
    workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-monitor/providers/Microsoft.Storage/storageAccounts/example"
  }
}

resource "azurerm_application_insights" "fail_missing_workspace_name" {
  expect_failure = true
  attrs = {
    workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-monitor/providers/Microsoft.OperationalInsights/workspaces/"
  }
}

resource "azurerm_application_insights" "fail_workspace_child_resource" {
  expect_failure = true
  attrs = {
    workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-monitor/providers/Microsoft.OperationalInsights/workspaces/law-pass/tables/AppRequests"
  }
}

resource "azurerm_application_insights" "fail_missing_subscription" {
  expect_failure = true
  attrs = {
    workspace_id = "/subscriptions//resourceGroups/rg-monitor/providers/Microsoft.OperationalInsights/workspaces/law-pass"
  }
}
