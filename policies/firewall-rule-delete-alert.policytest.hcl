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

resource "azurerm_monitor_activity_log_alert" "unrelated_but_ok" {
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
