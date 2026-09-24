locals {
  all_alerts = core::getresources("azurerm_monitor_activity_log_alert", {})

  qualifying_alerts = [
    for alert in local.all_alerts : alert
    if core::try(alert.enabled, true) == true
    && core::try(core::length([for a in core::try([for x in alert.action : x], []) : a if core::try(a.action_group_id, "") != ""]), 0) > 0
    && core::try(core::length([
      for c in core::try([for cr in alert.criteria : cr], []) : c
      if core::try(c.category, "") == "Administrative"
      && core::try(c.operation_name, "") == "Microsoft.Sql/servers/firewallRules/write"
    ]), 0) > 0
  ]

  has_qualifying_alert = core::try(core::length(local.qualifying_alerts), 0) > 0
}

resource_policy "*" "sql_firewall_rule_alert_exists" {
  enforcement_level = "advisory"

  enforce {
    condition     = local.has_qualifying_alert
    error_message = "An enabled activity log alert with an assigned action group must exist for category='Administrative' and operation_name='Microsoft.Sql/servers/firewallRules/write' (Create or Update SQL Server Firewall Rule)."
  }
}
