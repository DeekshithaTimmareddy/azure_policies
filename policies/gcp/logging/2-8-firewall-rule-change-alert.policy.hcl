# Copyright IBM Corp. 2026

# Ensure That the Log Metric Filter and Alerts Exist for VPC Network Firewall Rule Changes

policy {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0.0, < 8.0.0"
    }
  }
}

input "firewall-rule-alert-enforcement-level" {
  type    = string
  default = "advisory"
}

locals {
  firewall_change_metrics = core::try([for m in core::getresources("google_logging_metric", {}) : m], [])
  firewall_change_alerts  = core::try([for a in core::getresources("google_monitoring_alert_policy", {}) : a], [])
  firewall_method_pattern = "protoPayload\\.methodName\\s*:\\s*\"(v1\\.|beta\\.|alpha\\.)?compute\\.firewalls\\.(patch|insert|delete)\""
  firewall_filter_pattern = "^\\s*resource\\.type\\s*=\\s*\"gce_firewall_rule\"\\s+AND\\s+\\(\\s*${local.firewall_method_pattern}\\s+OR\\s+${local.firewall_method_pattern}\\s+OR\\s+${local.firewall_method_pattern}\\s*\\)\\s*$"

  firewall_metric_rows = [
    for m in local.firewall_change_metrics : {
      name   = core::try(m.name, null) == null ? "" : m.name
      filter = core::try(m.filter, null) == null ? "" : m.filter
    }
  ]

  firewall_metric_names = [
    for row in local.firewall_metric_rows : row.name
    if row.name != "" && core::try(core::regex(local.firewall_filter_pattern, row.filter), null) != null && core::contains_substring(row.filter, "compute.firewalls.patch") && core::contains_substring(row.filter, "compute.firewalls.insert") && core::contains_substring(row.filter, "compute.firewalls.delete")
  ]

  enabled_firewall_alert_filters = [
    for a in local.firewall_change_alerts :
    core::join(" ", [
      for c in core::try([for x in a.conditions : x], []) :
      core::join(" ", [
        core::try(c.condition_threshold[0].filter, null) == null ? "" : c.condition_threshold[0].filter,
        core::try(c.condition_absent[0].filter, null) == null ? "" : c.condition_absent[0].filter
      ])
    ])
    if core::try(a.enabled, null) != false && core::length([for ch in core::try([for y in a.notification_channels : y], []) : ch if ch != null && ch != ""]) > 0
  ]

  matched_firewall_pairs = [
    for name in local.firewall_metric_names : name
    if core::length([for filter in local.enabled_firewall_alert_filters : filter if core::try(core::contains_substring(filter, "logging.googleapis.com/user/${name}\""), false) || core::try(core::contains_substring(filter, "logging.googleapis.com/user/${name}\\\""), false) || core::try(core::contains_substring(filter, "logging.googleapis.com/user/${name} "), false) || core::try(core::endswith(filter, "logging.googleapis.com/user/${name}"), false)]) > 0
  ]

  firewall_change_control_compliant = core::length(local.matched_firewall_pairs) > 0
}

resource_policy "google_logging_metric" "firewall_rule_change_metric_and_alert" {
  filter = core::try(core::contains_substring(attrs.filter, "gce_firewall_rule"), false) || core::try(core::contains_substring(attrs.filter, "compute.firewalls."), false)

  enforcement_level = input.firewall-rule-alert-enforcement-level
  enforce {
    condition     = local.firewall_change_control_compliant
    error_message = "A VPC firewall rule change metric must cover patch, insert, and delete events and be referenced by an enabled alert with a notification channel."
  }
}

resource_policy "google_monitoring_alert_policy" "firewall_rule_change_metric_and_alert" {
  locals {
    filters = core::flatten([for condition in core::try([for item in attrs.conditions : item], []) : [for threshold in core::try([for item in condition.condition_threshold : item], []) : core::try(threshold.filter, "")]])
    references_firewall_metric = core::length([for name in local.firewall_metric_names : name if name != "" && core::length([for filter in local.filters : filter if core::try(core::regex("logging\\.googleapis\\.com/user/${name}([^A-Za-z0-9_./-]|$)", filter), null) != null]) > 0]) > 0
  }
  filter = local.references_firewall_metric

  enforcement_level = input.firewall-rule-alert-enforcement-level
  enforce {
    condition     = local.firewall_change_control_compliant
    error_message = "An enabled alert with a notification channel must reference a VPC firewall rule change metric."
  }
}
