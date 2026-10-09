# Copyright IBM Corp. 2026

policytest {
  targets = ["create-update-nsg-alert.policy.hcl"]
}

resource "azurerm_monitor_activity_log_alert" "fail_empty_scopes" {
  expect_failure = true
  attrs = {
    scopes = []
    criteria = [{ category = "Administrative", operation_name = "Microsoft.Network/networkSecurityGroups/write" }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_scopes_omitted" {
  expect_failure = true
  attrs = {
    criteria = [{ category = "Administrative", operation_name = "Microsoft.Network/networkSecurityGroups/write" }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_action_group_id_omitted" {
  expect_failure = true
  attrs = {
    name                = "fail-action-group-id-omitted"
    resource_group_name = "rg-alerts"
    location            = "global"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    action              = [{ webhook_properties = null }]
    criteria = [
      {
        category       = "Administrative"
        operation_name = "Microsoft.Network/networkSecurityGroups/write"
        caller = null
        level = null
        levels = null
        status = null
        statuses = null
        sub_status = null
        sub_statuses = null
        resource_group = null
        resource_groups = null
        resource_id = null
        resource_ids = null
        resource_provider = null
        resource_providers = null
        resource_type = null
        resource_types = null
      }
    ]
  }
}

resource "azurerm_monitor_activity_log_alert" "pass_known_action_group" {
  attrs = {
    name                = "pass-known-action-group"
    resource_group_name = "rg-alerts"
    location            = "global"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    action              = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security", webhook_properties = null }]
    criteria = [
      {
        category       = "Administrative"
        operation_name = "Microsoft.Network/networkSecurityGroups/write"
        caller = null
        level = null
        levels = null
        status = null
        statuses = null
        sub_status = null
        sub_statuses = null
        resource_group = null
        resource_groups = null
        resource_id = null
        resource_ids = null
        resource_provider = null
        resource_providers = null
        resource_type = null
        resource_types = null
      }
    ]
  }
}

resource "azurerm_monitor_activity_log_alert" "pass_enabled_omitted" {
  attrs = {
    name                = "pass-enabled-omitted"
    resource_group_name = "rg-alerts"
    location            = "global"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    action              = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security", webhook_properties = null }]
    criteria = [
      {
        category       = "Administrative"
        operation_name = "Microsoft.Network/networkSecurityGroups/write"
        caller = null
        level = null
        levels = null
        status = null
        statuses = null
        sub_status = null
        sub_statuses = null
        resource_group = null
        resource_groups = null
        resource_id = null
        resource_ids = null
        resource_provider = null
        resource_providers = null
        resource_type = null
        resource_types = null
      }
    ]
  }
}

resource "azurerm_monitor_activity_log_alert" "pass_enabled_null" {
  attrs = {
    name                = "pass-enabled-null"
    resource_group_name = "rg-alerts"
    location            = "global"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = null
    action              = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security", webhook_properties = null }]
    criteria = [
      {
        category       = "Administrative"
        operation_name = "Microsoft.Network/networkSecurityGroups/write"
        caller = null
        level = null
        levels = null
        status = null
        statuses = null
        sub_status = null
        sub_statuses = null
        resource_group = null
        resource_groups = null
        resource_id = null
        resource_ids = null
        resource_provider = null
        resource_providers = null
        resource_type = null
        resource_types = null
      }
    ]
  }
}

resource "azurerm_monitor_activity_log_alert" "pass_operation_and_category_mixed_case" {
  attrs = {
    name                = "pass-operation-and-category-mixed-case"
    resource_group_name = "rg-alerts"
    location            = "global"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    action              = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security", webhook_properties = null }]
    criteria = [
      {
        category       = " administrative "
        operation_name = "MICROSOFT.NETWORK/NETWORKSECURITYGROUPS/WRITE"
        caller = null
        level = null
        levels = null
        status = null
        statuses = null
        sub_status = null
        sub_statuses = null
        resource_group = null
        resource_groups = null
        resource_id = null
        resource_ids = null
        resource_provider = null
        resource_providers = null
        resource_type = null
        resource_types = null
      }
    ]
  }
}

resource "azurerm_monitor_activity_log_alert" "pass_multiple_action_groups" {
  attrs = {
    name                = "pass-multiple-action-groups"
    resource_group_name = "rg-alerts"
    location            = "global"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    action              = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security", webhook_properties = null }, { action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security-2", webhook_properties = { source = "cis" } }]
    criteria = [
      {
        category       = "Administrative"
        operation_name = "Microsoft.Network/networkSecurityGroups/write"
        caller = null
        level = null
        levels = null
        status = null
        statuses = null
        sub_status = null
        sub_statuses = null
        resource_group = null
        resource_groups = null
        resource_id = null
        resource_ids = null
        resource_provider = null
        resource_providers = null
        resource_type = null
        resource_types = null
      }
    ]
  }
}

resource "azurerm_monitor_activity_log_alert" "pass_subscription_scope_mixed_case_trailing_slash" {
  attrs = {
    name                = "pass-subscription-scope-mixed-case-trailing-slash"
    resource_group_name = "rg-alerts"
    location            = "global"
    scopes              = ["/Subscriptions/00000000-0000-0000-0000-000000000000/"]
    enabled             = true
    action              = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security", webhook_properties = null }]
    criteria = [
      {
        category       = "Administrative"
        operation_name = "Microsoft.Network/networkSecurityGroups/write"
        caller = null
        level = null
        levels = null
        status = null
        statuses = null
        sub_status = null
        sub_statuses = null
        resource_group = null
        resource_groups = null
        resource_id = null
        resource_ids = null
        resource_provider = null
        resource_providers = null
        resource_type = null
        resource_types = null
      }
    ]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_null_scopes" {
  expect_failure = true
  attrs = {
    name                = "fail-null-scopes"
    resource_group_name = "rg-alerts"
    location            = "global"
    scopes              = null
    enabled             = true
    action              = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security", webhook_properties = null }]
    criteria = [
      {
        category       = "Administrative"
        operation_name = "Microsoft.Network/networkSecurityGroups/write"
        caller = null
        level = null
        levels = null
        status = null
        statuses = null
        sub_status = null
        sub_statuses = null
        resource_group = null
        resource_groups = null
        resource_id = null
        resource_ids = null
        resource_provider = null
        resource_providers = null
        resource_type = null
        resource_types = null
      }
    ]
  }
}

resource "azurerm_monitor_activity_log_alert" "pass_blank_filter_values_ignored" {
  attrs = {
    name                = "pass-blank-filter-values-ignored"
    resource_group_name = "rg-alerts"
    location            = "global"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    action              = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security", webhook_properties = null }]
    criteria = [
      {
        category       = "Administrative"
        operation_name = "Microsoft.Network/networkSecurityGroups/write"
        caller = ""
        level = null
        levels = []
        status = null
        statuses = []
        sub_status = null
        sub_statuses = null
        resource_group = null
        resource_groups = null
        resource_id = null
        resource_ids = null
        resource_provider = null
        resource_providers = null
        resource_type = null
        resource_types = null
      }
    ]
  }
}

resource "azurerm_monitor_activity_log_alert" "pass_other_operation_out_of_scope" {
  attrs = {
    name                = "pass-other-operation-out-of-scope"
    resource_group_name = "rg-alerts"
    location            = "global"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = false
    action              = []
    criteria = [
      {
        category       = "Administrative"
        operation_name = "Microsoft.Authorization/policyAssignments/write"
        caller = null
        level = null
        levels = null
        status = null
        statuses = null
        sub_status = null
        sub_statuses = null
        resource_group = null
        resource_groups = null
        resource_id = null
        resource_ids = null
        resource_provider = null
        resource_providers = null
        resource_type = null
        resource_types = null
      }
    ]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_disabled" {
  attrs = {
    name                = "fail-disabled"
    resource_group_name = "rg-alerts"
    location            = "global"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = false
    action              = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security", webhook_properties = null }]
    criteria = [
      {
        category       = "Administrative"
        operation_name = "Microsoft.Network/networkSecurityGroups/write"
        caller = null
        level = null
        levels = null
        status = null
        statuses = null
        sub_status = null
        sub_statuses = null
        resource_group = null
        resource_groups = null
        resource_id = null
        resource_ids = null
        resource_provider = null
        resource_providers = null
        resource_type = null
        resource_types = null
      }
    ]
  }
  expect_failure = true
}

resource "azurerm_monitor_activity_log_alert" "fail_category_not_administrative" {
  attrs = {
    name                = "fail-category-not-administrative"
    resource_group_name = "rg-alerts"
    location            = "global"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    action              = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security", webhook_properties = null }]
    criteria = [
      {
        category       = "Policy"
        operation_name = "Microsoft.Network/networkSecurityGroups/write"
        caller = null
        level = null
        levels = null
        status = null
        statuses = null
        sub_status = null
        sub_statuses = null
        resource_group = null
        resource_groups = null
        resource_id = null
        resource_ids = null
        resource_provider = null
        resource_providers = null
        resource_type = null
        resource_types = null
      }
    ]
  }
  expect_failure = true
}

resource "azurerm_monitor_activity_log_alert" "fail_no_action" {
  attrs = {
    name                = "fail-no-action"
    resource_group_name = "rg-alerts"
    location            = "global"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    action              = []
    criteria = [
      {
        category       = "Administrative"
        operation_name = "Microsoft.Network/networkSecurityGroups/write"
        caller = null
        level = null
        levels = null
        status = null
        statuses = null
        sub_status = null
        sub_statuses = null
        resource_group = null
        resource_groups = null
        resource_id = null
        resource_ids = null
        resource_provider = null
        resource_providers = null
        resource_type = null
        resource_types = null
      }
    ]
  }
  expect_failure = true
}

resource "azurerm_monitor_activity_log_alert" "fail_blank_action_group_id" {
  attrs = {
    name                = "fail-blank-action-group-id"
    resource_group_name = "rg-alerts"
    location            = "global"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    action              = [{ action_group_id = "", webhook_properties = null }]
    criteria = [
      {
        category       = "Administrative"
        operation_name = "Microsoft.Network/networkSecurityGroups/write"
        caller = null
        level = null
        levels = null
        status = null
        statuses = null
        sub_status = null
        sub_statuses = null
        resource_group = null
        resource_groups = null
        resource_id = null
        resource_ids = null
        resource_provider = null
        resource_providers = null
        resource_type = null
        resource_types = null
      }
    ]
  }
  expect_failure = true
}

resource "azurerm_monitor_activity_log_alert" "fail_resource_group_scope_only" {
  attrs = {
    name                = "fail-resource-group-scope-only"
    resource_group_name = "rg-alerts"
    location            = "global"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-app"]
    enabled             = true
    action              = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security", webhook_properties = null }]
    criteria = [
      {
        category       = "Administrative"
        operation_name = "Microsoft.Network/networkSecurityGroups/write"
        caller = null
        level = null
        levels = null
        status = null
        statuses = null
        sub_status = null
        sub_statuses = null
        resource_group = null
        resource_groups = null
        resource_id = null
        resource_ids = null
        resource_provider = null
        resource_providers = null
        resource_type = null
        resource_types = null
      }
    ]
  }
  expect_failure = true
}

resource "azurerm_monitor_activity_log_alert" "fail_filters_on_caller" {
  attrs = {
    name                = "fail-filters-on-caller"
    resource_group_name = "rg-alerts"
    location            = "global"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    action              = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security", webhook_properties = null }]
    criteria = [
      {
        category       = "Administrative"
        operation_name = "Microsoft.Network/networkSecurityGroups/write"
        caller = "admin@example.com"
        level = null
        levels = null
        status = null
        statuses = null
        sub_status = null
        sub_statuses = null
        resource_group = null
        resource_groups = null
        resource_id = null
        resource_ids = null
        resource_provider = null
        resource_providers = null
        resource_type = null
        resource_types = null
      }
    ]
  }
  expect_failure = true
}

resource "azurerm_monitor_activity_log_alert" "fail_filters_on_level" {
  attrs = {
    name                = "fail-filters-on-level"
    resource_group_name = "rg-alerts"
    location            = "global"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    action              = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security", webhook_properties = null }]
    criteria = [
      {
        category       = "Administrative"
        operation_name = "Microsoft.Network/networkSecurityGroups/write"
        caller = null
        level = "Informational"
        levels = null
        status = null
        statuses = null
        sub_status = null
        sub_statuses = null
        resource_group = null
        resource_groups = null
        resource_id = null
        resource_ids = null
        resource_provider = null
        resource_providers = null
        resource_type = null
        resource_types = null
      }
    ]
  }
  expect_failure = true
}

resource "azurerm_monitor_activity_log_alert" "fail_filters_on_levels" {
  attrs = {
    name                = "fail-filters-on-levels"
    resource_group_name = "rg-alerts"
    location            = "global"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    action              = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security", webhook_properties = null }]
    criteria = [
      {
        category       = "Administrative"
        operation_name = "Microsoft.Network/networkSecurityGroups/write"
        caller = null
        level = null
        levels = ["Error"]
        status = null
        statuses = null
        sub_status = null
        sub_statuses = null
        resource_group = null
        resource_groups = null
        resource_id = null
        resource_ids = null
        resource_provider = null
        resource_providers = null
        resource_type = null
        resource_types = null
      }
    ]
  }
  expect_failure = true
}

resource "azurerm_monitor_activity_log_alert" "fail_filters_on_status" {
  attrs = {
    name                = "fail-filters-on-status"
    resource_group_name = "rg-alerts"
    location            = "global"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    action              = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security", webhook_properties = null }]
    criteria = [
      {
        category       = "Administrative"
        operation_name = "Microsoft.Network/networkSecurityGroups/write"
        caller = null
        level = null
        levels = null
        status = "Succeeded"
        statuses = null
        sub_status = null
        sub_statuses = null
        resource_group = null
        resource_groups = null
        resource_id = null
        resource_ids = null
        resource_provider = null
        resource_providers = null
        resource_type = null
        resource_types = null
      }
    ]
  }
  expect_failure = true
}

resource "azurerm_monitor_activity_log_alert" "fail_filters_on_statuses" {
  attrs = {
    name                = "fail-filters-on-statuses"
    resource_group_name = "rg-alerts"
    location            = "global"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    action              = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security", webhook_properties = null }]
    criteria = [
      {
        category       = "Administrative"
        operation_name = "Microsoft.Network/networkSecurityGroups/write"
        caller = null
        level = null
        levels = null
        status = null
        statuses = ["Failed"]
        sub_status = null
        sub_statuses = null
        resource_group = null
        resource_groups = null
        resource_id = null
        resource_ids = null
        resource_provider = null
        resource_providers = null
        resource_type = null
        resource_types = null
      }
    ]
  }
  expect_failure = true
}

resource "azurerm_monitor_activity_log_alert" "fail_filters_on_sub_status" {
  attrs = {
    name                = "fail-filters-on-sub-status"
    resource_group_name = "rg-alerts"
    location            = "global"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    action              = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security", webhook_properties = null }]
    criteria = [
      {
        category       = "Administrative"
        operation_name = "Microsoft.Network/networkSecurityGroups/write"
        caller = null
        level = null
        levels = null
        status = null
        statuses = null
        sub_status = "Created"
        sub_statuses = null
        resource_group = null
        resource_groups = null
        resource_id = null
        resource_ids = null
        resource_provider = null
        resource_providers = null
        resource_type = null
        resource_types = null
      }
    ]
  }
  expect_failure = true
}

resource "azurerm_monitor_activity_log_alert" "fail_filters_on_sub_statuses" {
  attrs = {
    name                = "fail-filters-on-sub-statuses"
    resource_group_name = "rg-alerts"
    location            = "global"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    action              = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security", webhook_properties = null }]
    criteria = [
      {
        category       = "Administrative"
        operation_name = "Microsoft.Network/networkSecurityGroups/write"
        caller = null
        level = null
        levels = null
        status = null
        statuses = null
        sub_status = null
        sub_statuses = ["OK"]
        resource_group = null
        resource_groups = null
        resource_id = null
        resource_ids = null
        resource_provider = null
        resource_providers = null
        resource_type = null
        resource_types = null
      }
    ]
  }
  expect_failure = true
}

resource "azurerm_monitor_activity_log_alert" "fail_filters_on_resource_group" {
  attrs = {
    name                = "fail-filters-on-resource-group"
    resource_group_name = "rg-alerts"
    location            = "global"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    action              = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security", webhook_properties = null }]
    criteria = [
      {
        category       = "Administrative"
        operation_name = "Microsoft.Network/networkSecurityGroups/write"
        caller = null
        level = null
        levels = null
        status = null
        statuses = null
        sub_status = null
        sub_statuses = null
        resource_group = "rg-app"
        resource_groups = null
        resource_id = null
        resource_ids = null
        resource_provider = null
        resource_providers = null
        resource_type = null
        resource_types = null
      }
    ]
  }
  expect_failure = true
}

resource "azurerm_monitor_activity_log_alert" "fail_filters_on_resource_groups" {
  attrs = {
    name                = "fail-filters-on-resource-groups"
    resource_group_name = "rg-alerts"
    location            = "global"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    action              = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security", webhook_properties = null }]
    criteria = [
      {
        category       = "Administrative"
        operation_name = "Microsoft.Network/networkSecurityGroups/write"
        caller = null
        level = null
        levels = null
        status = null
        statuses = null
        sub_status = null
        sub_statuses = null
        resource_group = null
        resource_groups = ["rg-app"]
        resource_id = null
        resource_ids = null
        resource_provider = null
        resource_providers = null
        resource_type = null
        resource_types = null
      }
    ]
  }
  expect_failure = true
}

resource "azurerm_monitor_activity_log_alert" "fail_filters_on_resource_id" {
  attrs = {
    name                = "fail-filters-on-resource-id"
    resource_group_name = "rg-alerts"
    location            = "global"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    action              = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security", webhook_properties = null }]
    criteria = [
      {
        category       = "Administrative"
        operation_name = "Microsoft.Network/networkSecurityGroups/write"
        caller = null
        level = null
        levels = null
        status = null
        statuses = null
        sub_status = null
        sub_statuses = null
        resource_group = null
        resource_groups = null
        resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-app"
        resource_ids = null
        resource_provider = null
        resource_providers = null
        resource_type = null
        resource_types = null
      }
    ]
  }
  expect_failure = true
}

resource "azurerm_monitor_activity_log_alert" "fail_filters_on_resource_ids" {
  attrs = {
    name                = "fail-filters-on-resource-ids"
    resource_group_name = "rg-alerts"
    location            = "global"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    action              = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security", webhook_properties = null }]
    criteria = [
      {
        category       = "Administrative"
        operation_name = "Microsoft.Network/networkSecurityGroups/write"
        caller = null
        level = null
        levels = null
        status = null
        statuses = null
        sub_status = null
        sub_statuses = null
        resource_group = null
        resource_groups = null
        resource_id = null
        resource_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-app"]
        resource_provider = null
        resource_providers = null
        resource_type = null
        resource_types = null
      }
    ]
  }
  expect_failure = true
}

resource "azurerm_monitor_activity_log_alert" "fail_filters_on_resource_provider" {
  attrs = {
    name                = "fail-filters-on-resource-provider"
    resource_group_name = "rg-alerts"
    location            = "global"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    action              = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security", webhook_properties = null }]
    criteria = [
      {
        category       = "Administrative"
        operation_name = "Microsoft.Network/networkSecurityGroups/write"
        caller = null
        level = null
        levels = null
        status = null
        statuses = null
        sub_status = null
        sub_statuses = null
        resource_group = null
        resource_groups = null
        resource_id = null
        resource_ids = null
        resource_provider = "Microsoft.Network"
        resource_providers = null
        resource_type = null
        resource_types = null
      }
    ]
  }
  expect_failure = true
}

resource "azurerm_monitor_activity_log_alert" "fail_filters_on_resource_providers" {
  attrs = {
    name                = "fail-filters-on-resource-providers"
    resource_group_name = "rg-alerts"
    location            = "global"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    action              = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security", webhook_properties = null }]
    criteria = [
      {
        category       = "Administrative"
        operation_name = "Microsoft.Network/networkSecurityGroups/write"
        caller = null
        level = null
        levels = null
        status = null
        statuses = null
        sub_status = null
        sub_statuses = null
        resource_group = null
        resource_groups = null
        resource_id = null
        resource_ids = null
        resource_provider = null
        resource_providers = ["Microsoft.Network"]
        resource_type = null
        resource_types = null
      }
    ]
  }
  expect_failure = true
}

resource "azurerm_monitor_activity_log_alert" "fail_filters_on_resource_type" {
  attrs = {
    name                = "fail-filters-on-resource-type"
    resource_group_name = "rg-alerts"
    location            = "global"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    action              = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security", webhook_properties = null }]
    criteria = [
      {
        category       = "Administrative"
        operation_name = "Microsoft.Network/networkSecurityGroups/write"
        caller = null
        level = null
        levels = null
        status = null
        statuses = null
        sub_status = null
        sub_statuses = null
        resource_group = null
        resource_groups = null
        resource_id = null
        resource_ids = null
        resource_provider = null
        resource_providers = null
        resource_type = "Microsoft.Network/networkSecurityGroups"
        resource_types = null
      }
    ]
  }
  expect_failure = true
}

resource "azurerm_monitor_activity_log_alert" "fail_filters_on_resource_types" {
  attrs = {
    name                = "fail-filters-on-resource-types"
    resource_group_name = "rg-alerts"
    location            = "global"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    action              = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security", webhook_properties = null }]
    criteria = [
      {
        category       = "Administrative"
        operation_name = "Microsoft.Network/networkSecurityGroups/write"
        caller = null
        level = null
        levels = null
        status = null
        statuses = null
        sub_status = null
        sub_statuses = null
        resource_group = null
        resource_groups = null
        resource_id = null
        resource_ids = null
        resource_provider = null
        resource_providers = null
        resource_type = null
        resource_types = ["Microsoft.Network/networkSecurityGroups"]
      }
    ]
  }
  expect_failure = true
}

resource "azurerm_monitor_activity_log_alert" "pass_nsg_delete_out_of_scope" {
  attrs = {
    enabled = false
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Network/networkSecurityGroups/delete"
    }]
    action = []
  }
}

resource "azurerm_monitor_activity_log_alert" "pass_operation_whitespace" {
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{
      category       = "Administrative"
      operation_name = " Microsoft.Network/networkSecurityGroups/write "
    }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_null_action_group_id" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Network/networkSecurityGroups/write"
    }]
    action = [{ action_group_id = null }]
  }
}

resource "azurerm_monitor_activity_log_alert" "pass_subscription_and_resource_group_scopes" {
  attrs = {
    scopes = [
      "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts",
      "/subscriptions/00000000-0000-0000-0000-000000000000",
    ]
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Network/networkSecurityGroups/write"
    }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_empty_action_list" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Network/networkSecurityGroups/write"
    }]
    action = []
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_resource_scope_only" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Network/networkSecurityGroups/nsg-example"]
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Network/networkSecurityGroups/write"
    }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_cis_remediation_level_verbose" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Network/networkSecurityGroups/write"
      level          = "Verbose"
    }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}
