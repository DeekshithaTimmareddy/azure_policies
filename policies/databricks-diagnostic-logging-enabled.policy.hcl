# Copyright IBM Corp. 2026

# Ensure that Diagnostic Log Delivery is Configured for Azure Databricks

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "databricks-diagnostic-logging-enabled-enforcement-level" {
  type    = string
  default = "advisory"
}

locals {
  databricks_diagnostic_settings = core::getresources("azurerm_monitor_diagnostic_setting", {})
  databricks_required_log_categories = ["accounts", "Filesystem", "clusters", "notebook", "jobs"]
}

resource_policy "azurerm_databricks_workspace" "diagnostic_log_delivery" {
  locals {
    workspace_id_raw = core::try(attrs.id, null)
    workspace_id     = local.workspace_id_raw == null ? "" : local.workspace_id_raw

    matching_diagnostic_settings = [
      for setting in local.databricks_diagnostic_settings : setting
      if local.workspace_id != "" &&
      core::lower(core::try(setting.target_resource_id, "")) == core::lower(local.workspace_id)
    ]

    settings_with_destination = [
      for setting in local.matching_diagnostic_settings : setting
      if core::try(core::regex("[^ \\t\\r\\n]", core::try(setting.log_analytics_workspace_id, "")), null) != null ||
      core::try(core::regex("[^ \\t\\r\\n]", core::try(setting.storage_account_id, "")), null) != null ||
      core::try(core::regex("[^ \\t\\r\\n]", core::try(setting.eventhub_authorization_rule_id, "")), null) != null
    ]

    required_categories_covered = [
      for required_category in local.databricks_required_log_categories : required_category
      if core::length([
        for setting in local.settings_with_destination : setting
        if core::length([
          for log in core::try([for item in setting.enabled_log : item], []) : log
          if core::lower(core::try(log.category, "")) == core::lower(required_category) ||
          core::lower(core::try(log.category_group, "")) == "alllogs"
        ]) > 0
      ]) > 0
    ]
  }

  enforcement_level = input.databricks-diagnostic-logging-enabled-enforcement-level

  enforce {
    condition     = core::lower(core::try(attrs.sku, "")) == "premium" && core::length(local.required_categories_covered) == core::length(local.databricks_required_log_categories)
    error_message = "Each Azure Databricks workspace must use the Premium plan and have diagnostic settings that collectively enable accounts, Filesystem, clusters, notebook, and jobs logs (or allLogs), with each required category routed to Log Analytics, Storage, or Event Hub."
  }
}
