policytest {
  targets = ["firewall-rule-create-update-alert.policy.hcl"]
}

resource "azurerm_monitor_activity_log_alert" "disabled_fail" {
  expect_failure = true
  attrs = {
    name                = "sql-fw-rule-alert-disabled"
    location            = "global"
    resource_group_name = "monitoring-rg"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = false
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Sql/servers/firewallRules/write"
    }]
    action = [{
      action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/monitoring-rg/providers/Microsoft.Insights/actionGroups/ag1"
    }]
  }
}
