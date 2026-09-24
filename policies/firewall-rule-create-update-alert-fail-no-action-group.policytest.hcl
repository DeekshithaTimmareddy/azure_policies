policytest {
  targets = ["firewall-rule-create-update-alert.policy.hcl"]
}

resource "azurerm_monitor_activity_log_alert" "no_action_group_fail" {
  expect_failure = true
  attrs = {
    name                = "sql-fw-rule-alert-noaction"
    location            = "global"
    resource_group_name = "monitoring-rg"
    scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
    enabled             = true
    criteria = [{
      category       = "Administrative"
      operation_name = "Microsoft.Sql/servers/firewallRules/write"
    }]
  }
}
