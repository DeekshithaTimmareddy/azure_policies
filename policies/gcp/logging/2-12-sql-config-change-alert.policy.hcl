# Copyright IBM Corp. 2026

# Ensure That the Log Metric Filter and Alerts Exist for SQL Instance Configuration Changes

policy {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0.0, < 8.0.0"
    }
  }
}

input "sql-config-alert-enforcement-level" {
  type    = string
  default = "advisory"
}

locals {
  prescribed_sql_update_filter = "^\\s*protoPayload\\.methodName\\s*=\\s*\"cloudsql\\.instances\\.update\"\\s*$"

  sql_change_metrics = core::getresources("google_logging_metric", {})
  sql_change_alerts  = core::getresources("google_monitoring_alert_policy", {})

  sql_metric_names = [for metric in local.sql_change_metrics : core::try(metric.name, "") if core::try(core::regex(local.prescribed_sql_update_filter, core::try(metric.filter, null) == null ? "" : metric.filter), null) != null && core::try(metric.name, null) != null && core::try(metric.name, "") != ""]

  eligible_sql_alerts = [for alert in local.sql_change_alerts : alert if core::try(alert.enabled, null) != false && core::length([for channel in core::try([for item in alert.notification_channels : item], []) : channel if channel != null && channel != ""]) > 0]

  sql_alert_threshold_filters = core::flatten([for alert in local.eligible_sql_alerts : [for condition in core::try([for item in alert.conditions : item], []) : core::try(condition.condition_threshold[0].filter, null) == null ? "" : condition.condition_threshold[0].filter]])
}

resource_policy "google_logging_metric" "sql_instance_config_change_metric" {
  locals {
    filter_raw = core::try(attrs.filter, null)
    filter     = local.filter_raw == null ? "" : local.filter_raw
    name_raw   = core::try(attrs.name, null)
    name       = local.name_raw == null ? "" : local.name_raw
    in_scope   = local.filter == "" || core::contains_substring(local.filter, "cloudsql.instances.")
    prescribed = core::try(core::regex(local.prescribed_sql_update_filter, local.filter), null) != null
    ref        = "logging.googleapis.com/user/${local.name}"
    alerted    = core::length([for filter in local.sql_alert_threshold_filters : filter if core::contains_substring(filter, "${local.ref}\"") || core::contains_substring(filter, "${local.ref}\\\"") || core::endswith(filter, local.ref)]) > 0
  }
  filter = local.in_scope

  enforcement_level = input.sql-config-alert-enforcement-level
  enforce {
    condition     = local.name != "" && local.prescribed && local.alerted
    error_message = "SQL instance configuration metric '${local.name}' must use the prescribed update filter and be referenced by an enabled alert threshold with a notification channel."
  }
}

resource_policy "google_monitoring_alert_policy" "sql_instance_config_change_alert" {
  locals {
    enabled_raw = core::try(attrs.enabled, null)
    is_disabled = local.enabled_raw == false
    has_channel = core::length([for channel in core::try([for item in attrs.notification_channels : item], []) : channel if channel != null && channel != ""]) > 0
    filters     = [for condition in core::try([for item in attrs.conditions : item], []) : core::try(condition.condition_threshold[0].filter, null) == null ? "" : condition.condition_threshold[0].filter]
    linked      = core::length([for name in local.sql_metric_names : name if core::length([for filter in local.filters : filter if core::contains_substring(filter, "logging.googleapis.com/user/${name}\"") || core::contains_substring(filter, "logging.googleapis.com/user/${name}\\\"") || core::endswith(filter, "logging.googleapis.com/user/${name}")]) > 0]) > 0
  }
  enforcement_level = input.sql-config-alert-enforcement-level
  enforce {
    condition     = !local.linked || (!local.is_disabled && local.has_channel)
    error_message = "An alert policy referencing a SQL instance configuration metric must be enabled and have a notification channel."
  }
}
