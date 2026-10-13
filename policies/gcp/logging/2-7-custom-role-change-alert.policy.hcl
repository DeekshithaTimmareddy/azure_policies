# Copyright IBM Corp. 2026

# Ensure That the Log Metric Filter and Alerts Exist for Custom Role Changes

policy {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0.0, < 8.0.0"
    }
  }
}

input "custom-role-alert-enforcement-level" {
  type    = string
  default = "advisory"
}

locals {
  all_metrics = core::try([for m in core::getresources("google_logging_metric", {}) : m], [])
  all_alerts  = core::try([for a in core::getresources("google_monitoring_alert_policy", {}) : a], [])
  custom_role_filter_pattern = "^\\s*resource\\.type\\s*=\\s*\"iam_role\"\\s+AND\\s+\\(\\s*protoPayload\\.methodName\\s*=\\s*\"google\\.iam\\.admin\\.v1\\.CreateRole\"\\s+OR\\s+protoPayload\\.methodName\\s*=\\s*\"google\\.iam\\.admin\\.v1\\.DeleteRole\"\\s+OR\\s+protoPayload\\.methodName\\s*=\\s*\"google\\.iam\\.admin\\.v1\\.UpdateRole\"\\s+OR\\s+protoPayload\\.methodName\\s*=\\s*\"google\\.iam\\.admin\\.v1\\.UndeleteRole\"\\s*\\)\\s*$"

  # Alert policies not explicitly disabled
  enabled_alerts = [for a in local.all_alerts : a if core::try(a.enabled, null) != false]

  # One concatenated filter/query string per enabled alert (all conditions)
  enabled_alert_filters = [for a in local.enabled_alerts : core::join(" ", [for c in core::try([for x in a.conditions : x], []) : core::join(" ", [core::try(c.condition_threshold[0].filter, null) == null ? "" : c.condition_threshold[0].filter, core::try(c.condition_absent[0].filter, null) == null ? "" : c.condition_absent[0].filter, core::try(c.condition_monitoring_query_language[0].query, null) == null ? "" : c.condition_monitoring_query_language[0].query])])]

  # Metrics whose filter matches the prescribed filter
  matching_metric_names = [for m in local.all_metrics : (core::try(m.name, null) == null ? "" : m.name) if core::try(core::regex(local.custom_role_filter_pattern, core::try(m.filter, "")), null) != null]

  alerted_metric_names = [for n in local.matching_metric_names : n if n != "" && core::length([for f in local.enabled_alert_filters : f if core::try(core::regex("logging\\.googleapis\\.com/user/${n}([^A-Za-z0-9_./-]|$)", f), null) != null]) > 0]

  control_satisfied = core::length(local.alerted_metric_names) > 0
}

provider_policy "google" "custom_role_changes_metric_alert_project" {
  enforcement_level = input.custom-role-alert-enforcement-level
  enforce {
    condition     = local.control_satisfied
    error_message = "At least one custom-role log metric with the prescribed filter must be referenced by an enabled google_monitoring_alert_policy."
  }
}

resource_policy "google_logging_metric" "custom_role_changes_metric_alert" {
  locals {
    f    = core::try(attrs.filter, null) == null ? "" : attrs.filter
    name = core::try(attrs.name, null) == null ? "" : attrs.name
    is_candidate = local.f == "" || core::try(core::contains_substring(local.f, "iam_role"), false) || core::try(core::contains_substring(local.f, "google.iam.admin.v1."), false)
    filter_ok = core::try(core::regex(local.custom_role_filter_pattern, local.f), null) != null
    alert_ok  = local.name != "" && core::length([for af in local.enabled_alert_filters : af if core::try(core::regex("logging\\.googleapis\\.com/user/${local.name}([^A-Za-z0-9_./-]|$)", af), null) != null]) > 0
  }

  filter = local.is_candidate

  enforcement_level = input.custom-role-alert-enforcement-level
  enforce {
    condition     = local.filter_ok && local.alert_ok
    error_message = "Custom-role log metric '${local.name}' must use the prescribed filter and be referenced by an enabled alert policy condition."
  }
}
