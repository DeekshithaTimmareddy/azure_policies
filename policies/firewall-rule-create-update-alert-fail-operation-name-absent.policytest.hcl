policytest {
  targets = ["firewall-rule-create-update-alert.policy.hcl"]
}

resource "azurerm_monitor_activity_log_alert" "operation_name_absent_fail" {
  expect_failure = true
  attrs = {
    name                = "sql-fw-rule-alert-noop"
    location            = "global"
    resource_group_name = "monitoring-rg"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    criteria = [{
      category = "Administrative"
    }]
    action = [{
      action_group_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/monitoring-rg/providers/Microsoft.Insights/actionGroups/ag1"
    }]
  }
}
