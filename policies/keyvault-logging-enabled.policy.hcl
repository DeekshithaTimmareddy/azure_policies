resource_policy "azurerm_monitor_diagnostic_setting" "keyvault_logging_enabled" {
    enforcement_level = "advisory"

    filter = core::contains_substring(core::try(attrs.target_resource_id, ""), "Microsoft.KeyVault/vaults/")

    enforce {
        condition = (core::try(attrs.storage_account_id, "") != "" || core::try(attrs.log_analytics_workspace_id, "") != "" || core::try(attrs.eventhub_authorization_rule_id, "") != "" || core::try(attrs.partner_solution_id, "") != "") && core::try(core::length([for el in core::try([for l in attrs.enabled_log : l], []) : el if core::try(el.category, "") == "AuditEvent" || core::try(el.category_group, "") == "audit"]), 0) > 0 && core::try(core::length([for el in core::try([for l in attrs.enabled_log : l], []) : el if core::try(el.category_group, "") == "allLogs"]), 0) > 0
        error_message = "Key Vault diagnostic setting must send logs to a configured destination and enable both the 'audit' (AuditEvent) and 'allLogs' category groups via enabled_log."
    }
}
