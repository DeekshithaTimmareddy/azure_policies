# Copyright IBM Corp. 2026

policytest {
  targets = ["service-health-alert.policy.hcl"]
}

resource "azurerm_monitor_activity_log_alert" "fail_empty_scopes" {
  expect_failure = true
  attrs = {
    scopes = []
    criteria = [{ category = "ServiceHealth" }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_scopes_omitted" {
  expect_failure = true
  attrs = {
    criteria = [{ category = "ServiceHealth" }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_null_action_group_id" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth" }]
    action = [{ action_group_id = null }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_action_group_id_omitted" {
  expect_failure = true
  attrs = {
    enabled = true
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{
      category = "ServiceHealth"
      service_health = null
      operation_name = null
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
    }]
    action = [{ webhook_properties = null }]
  }
}

resource "azurerm_monitor_activity_log_alert" "pass_known_action_group" {
  attrs = {
    enabled = true
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth" }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "pass_enabled_omitted" {
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth" }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "pass_enabled_null" {
  attrs = {
    enabled = null
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth" }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "pass_category_normalized" {
  attrs = {
    scopes = ["/SUBSCRIPTIONS/00000000-0000-0000-0000-000000000000/"]
    criteria = [{ category = " serviceHEALTH " }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_null_scopes" {
  expect_failure = true
  attrs = {
    scopes = null
    criteria = [{ category = "ServiceHealth" }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "pass_multiple_scopes_and_actions" {
  attrs = {
    scopes = [
      "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts",
      "/subscriptions/00000000-0000-0000-0000-000000000000",
      null,
    ]
    criteria = [{ category = "ServiceHealth" }]
    action = [
      { action_group_id = " " },
      { action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" },
    ]
  }
}

resource "azurerm_monitor_activity_log_alert" "pass_empty_service_health_block" {
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", service_health = [{}] }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "pass_empty_service_health_collections" {
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", service_health = [{ events = [], services = [], locations = [] }] }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "pass_null_service_health_collections" {
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", service_health = [{ events = null, services = null, locations = null }] }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "pass_all_explicit_events" {
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", service_health = [{ events = ["Incident", "Maintenance", "Informational", "ActionRequired", "Security"] }] }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "pass_events_normalized_and_reordered" {
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", service_health = [{ events = [" SECURITY ", "ActionRequired", "informational", "maintenance", "INCIDENT"] }] }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "pass_region_selection" {
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", service_health = [{ locations = ["East US"] }] }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "pass_blank_and_empty_generic_filters" {
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", caller = " ", operation_name = "", levels = [], statuses = [], resource_types = [] }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "pass_administrative_out_of_scope" {
  attrs = {
    enabled = false
    scopes = []
    criteria = [{ category = "Administrative", operation_name = "Microsoft.Network/publicIPAddresses/delete" }]
    action = []
  }
}

resource "azurerm_monitor_activity_log_alert" "pass_resource_health_out_of_scope" {
  attrs = {
    enabled = false
    criteria = [{ category = "ResourceHealth" }]
    action = []
  }
}

resource "azurerm_monitor_action_group" "pass_action_group_out_of_scope" {
  attrs = {
    name = "unrelated-action-group"
    short_name = "unrelated"
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_disabled" {
  expect_failure = true
  attrs = {
    enabled = false
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth" }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_resource_group_scope" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts"]
    criteria = [{ category = "ServiceHealth" }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_resource_scope" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Storage/storageAccounts/example"]
    criteria = [{ category = "ServiceHealth" }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_mixed_null_or_omitted_and_resource_group_scope" {
  expect_failure = true
  attrs = {
    scopes = [null, "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts"]
    criteria = [{ category = "ServiceHealth" }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_action_missing" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_action_empty" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth" }]
    action = []
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_blank_action_group" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth" }]
    action = [{ action_group_id = "  " }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_selected_service" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", service_health = [{ services = ["Virtual Machines"] }] }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_literal_all_service" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", service_health = [{ services = ["All"] }] }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_incident_only_remediation" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", service_health = [{ events = ["Incident"] }] }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_missing_incident" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", service_health = [{ events = ["Maintenance", "Informational", "ActionRequired", "Security"] }] }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_missing_maintenance" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", service_health = [{ events = ["Incident", "Informational", "ActionRequired", "Security"] }] }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_missing_informational" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", service_health = [{ events = ["Incident", "Maintenance", "ActionRequired", "Security"] }] }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_missing_action_required" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", service_health = [{ events = ["Incident", "Maintenance", "Informational", "Security"] }] }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_missing_security" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", service_health = [{ events = ["Incident", "Maintenance", "Informational", "ActionRequired"] }] }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_operation_name" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", operation_name = "Microsoft.Network/publicIPAddresses/delete" }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_caller" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", caller = "operator@example.com" }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_level" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", level = "Informational" }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_levels" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", levels = ["Informational"] }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_status" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", status = "Succeeded" }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_statuses" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", statuses = ["Succeeded"] }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_sub_status" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", sub_status = "OK" }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_sub_statuses" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", sub_statuses = ["OK"] }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_resource_group" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", resource_group = "rg-alerts" }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_resource_groups" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", resource_groups = ["rg-alerts"] }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_resource_id" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Storage/storageAccounts/example" }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_resource_ids" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", resource_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Storage/storageAccounts/example"] }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_resource_provider" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", resource_provider = "Microsoft.Storage" }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_resource_providers" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", resource_providers = ["Microsoft.Storage"] }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_resource_type" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", resource_type = "Microsoft.Storage/storageAccounts" }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_resource_types" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", resource_types = ["Microsoft.Storage/storageAccounts"] }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "pass_empty_resource_health_filters" {
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", resource_health = [{ current = [], previous = null, reason = [] }] }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_recommendation_type" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", recommendation_type = "sample-recommendation" }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_recommendation_category" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", recommendation_category = "Security" }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_recommendation_impact" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", recommendation_impact = "High" }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_resource_health_current" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", resource_health = [{ current = ["Degraded"] }] }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_resource_health_previous" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", resource_health = [{ previous = ["Available"] }] }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}

resource "azurerm_monitor_activity_log_alert" "fail_resource_health_reason" {
  expect_failure = true
  attrs = {
    scopes = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    criteria = [{ category = "ServiceHealth", resource_health = [{ reason = ["PlatformInitiated"] }] }]
    action = [{ action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-alerts/providers/Microsoft.Insights/actionGroups/ag-security" }]
  }
}
