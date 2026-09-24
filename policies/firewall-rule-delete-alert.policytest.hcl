policytest {
  targets = ["firewall-rule-delete-alert.policy.hcl"]
}

resource "azurerm_monitor_activity_log_alert" "compliant_delete_fw_rule" {
  attrs = {
    location            = "global"
    name                = "delete-sql-fw-rule-alert"
    resource_group_name = "rg-monitoring"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Sql/servers/firewallRules/delete"
    }]
    action = [{
      action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-monitoring/providers/Microsoft.Insights/actionGroups/ag-notify"
    }]
  }
}

resource "azurerm_monitor_activity_log_alert" "compliant_no_extra_filters" {
  attrs = {
    location            = "global"
    name                = "delete-sql-fw-rule-alert-2"
    resource_group_name = "rg-monitoring"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Sql/servers/firewallRules/delete"
    }]
    action = [{
      action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-monitoring/providers/Microsoft.Insights/actionGroups/ag-secops"
    }]
  }
}

resource "azurerm_monitor_activity_log_alert" "compliant_matches_official_remediation" {
  attrs = {
    location            = "global"
    name                = "delete-sql-fw-rule-remediation"
    resource_group_name = "rg-monitoring"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Sql/servers/firewallRules/delete"
      level          = "Verbose"
    }]
    action = [{
      action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-monitoring/providers/Microsoft.Insights/actionGroups/ag-notify"
    }]
  }
}

resource "azurerm_monitor_activity_log_alert" "wrong_operation" {
  expect_failure = true
  attrs = {
    location            = "global"
    name                = "delete-sql-db-alert"
    resource_group_name = "rg-monitoring"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Sql/servers/databases/delete"
    }]
    action = [{
      action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-monitoring/providers/Microsoft.Insights/actionGroups/ag-notify"
    }]
  }
}

resource "azurerm_monitor_activity_log_alert" "no_operation" {
  expect_failure = true
  attrs = {
    location            = "global"
    name                = "admin-alert-no-op"
    resource_group_name = "rg-monitoring"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    criteria = [{
      category = "Administrative"
    }]
    action = [{
      action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-monitoring/providers/Microsoft.Insights/actionGroups/ag-notify"
    }]
  }
}

resource "azurerm_monitor_activity_log_alert" "wrong_category" {
  expect_failure = true
  attrs = {
    location            = "global"
    name                = "delete-sql-fw-rule-security"
    resource_group_name = "rg-monitoring"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    criteria = [{
      category       = "Security"
      operation_name = "Microsoft.Sql/servers/firewallRules/delete"
    }]
    action = [{
      action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-monitoring/providers/Microsoft.Insights/actionGroups/ag-notify"
    }]
  }
}

resource "azurerm_monitor_activity_log_alert" "disabled" {
  expect_failure = true
  attrs = {
    location            = "global"
    name                = "delete-sql-fw-rule-disabled"
    resource_group_name = "rg-monitoring"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = false
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Sql/servers/firewallRules/delete"
    }]
    action = [{
      action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-monitoring/providers/Microsoft.Insights/actionGroups/ag-notify"
    }]
  }
}

resource "azurerm_monitor_activity_log_alert" "no_action" {
  expect_failure = true
  attrs = {
    location            = "global"
    name                = "delete-sql-fw-rule-no-action"
    resource_group_name = "rg-monitoring"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Sql/servers/firewallRules/delete"
    }]
  }
}

resource "azurerm_monitor_activity_log_alert" "empty_action_group" {
  expect_failure = true
  attrs = {
    location            = "global"
    name                = "delete-sql-fw-rule-empty-ag"
    resource_group_name = "rg-monitoring"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Sql/servers/firewallRules/delete"
    }]
    action = [{
      action_group_id = ""
    }]
  }
}
