resource_policy "azurerm_monitor_activity_log_alert" "activity_log_alert_delete_sql_firewall_rule" {
  enforcement_level = "advisory"

  enforce {
    condition     = (core::try(attrs.enabled, null) == null ? true : core::try(attrs.enabled, null)) == true && core::length([for c in core::try([for x in attrs.criteria : x], []) : c if core::try(c.category, "") == "Administrative" && core::try(c.operation_name, "") == "Microsoft.Sql/servers/firewallRules/delete"]) > 0 && core::length([for a in core::try([for x in attrs.action : x], []) : a if core::try(a.action_group_id, "") != ""]) > 0
    error_message = "This activity log alert must be enabled and configured for the 'Delete SQL Server Firewall Rule' operation (category=Administrative, operationName=Microsoft.Sql/servers/firewallRules/delete) with an action group assigned."
  }
}
