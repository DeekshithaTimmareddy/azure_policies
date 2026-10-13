# Copyright IBM Corp. 2026

# Ensure That the Log Metric Filter and Alerts Exist for VPC Network Changes

policy {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0.0, < 8.0.0"
    }
  }
}

input "network-change-alert-enforcement-level" {
  type    = string
  default = "advisory"
}

locals {
  network_change_alert_policies = core::try([for policy in core::getresources("google_monitoring_alert_policy", {}) : policy], [])
  network_change_metrics        = core::try([for metric in core::getresources("google_logging_metric", {}) : metric], [])

  enabled_network_alert_filters = core::flatten([for policy in local.network_change_alert_policies : [for condition in core::try([for item in policy.conditions : item], []) : [for threshold in core::try([for item in condition.condition_threshold : item], []) : (core::try(threshold.filter, null) == null ? "" : threshold.filter)]] if core::try(policy.enabled, null) != false && core::length([for channel in core::try([for item in policy.notification_channels : item], []) : channel if channel != null && channel != ""]) > 0])

  network_metric_rows = [for metric in local.network_change_metrics : {
    name   = core::try(metric.name, null) == null ? "" : metric.name
    filter = core::try(metric.filter, null) == null ? "" : metric.filter
  }]

  network_metric_names = [
    for row in local.network_metric_rows : row.name
    if row.name != "" && core::try(core::regex("^\\s*resource\\.type\\s*=\\s*\\\\?\"gce_network\\\\?\"\\s+AND\\s+.*$", row.filter), null) != null && core::try(core::contains_substring(row.filter, "compute.networks.insert"), false) && core::try(core::contains_substring(row.filter, "compute.networks.patch"), false) && core::try(core::contains_substring(row.filter, "compute.networks.delete"), false) && core::try(core::contains_substring(row.filter, "compute.networks.removePeering"), false) && core::try(core::contains_substring(row.filter, "compute.networks.addPeering"), false) && core::length(core::split(" AND ", row.filter)) == 2 && core::length(core::split(" OR ", row.filter)) == 5 && core::try(core::regex("(^|[\\s(])(NOT\\s|-\\s*protoPayload|-\\s*resource|!)", row.filter), null) == null
  ]
}

resource_policy "google_logging_metric" "vpc_network_change_metric_and_alert" {
  locals {
    name_raw   = core::try(attrs.name, null)
    name       = local.name_raw == null ? "" : local.name_raw
    filter_raw = core::try(attrs.filter, null)
    filter     = local.filter_raw == null ? "" : local.filter_raw
    in_scope = local.filter == "" || core::contains_substring(local.filter, "gce_network") || core::contains_substring(local.filter, "compute.networks.")
    is_vpc  = core::contains(local.network_metric_names, local.name)
    alerted = local.name != "" && core::length([for filter in local.enabled_network_alert_filters : filter if core::try(core::regex("logging\\.googleapis\\.com/user/${local.name}([^A-Za-z0-9_./-]|$)", filter), null) != null]) > 0
  }
  filter = local.in_scope

  enforcement_level = input.network-change-alert-enforcement-level
  enforce {
    condition     = local.is_vpc && local.alerted
    error_message = "VPC network-change metric '${local.name}' must cover all five network operations and be referenced by an enabled alert with a notification channel."
  }
}

resource_policy "google_monitoring_alert_policy" "vpc_network_change_alert_enabled" {
  locals {
    enabled_raw = core::try(attrs.enabled, null)
    filters     = core::flatten([for condition in core::try([for item in attrs.conditions : item], []) : [for threshold in core::try([for item in condition.condition_threshold : item], []) : (core::try(threshold.filter, null) == null ? "" : threshold.filter)]])
    refs_vpc    = core::length([for name in local.network_metric_names : name if name != "" && core::length([for filter in local.filters : filter if core::try(core::regex("logging\\.googleapis\\.com/user/${name}([^A-Za-z0-9_./-]|$)", filter), null) != null]) > 0]) > 0
    has_channel = core::length([for channel in core::try([for item in attrs.notification_channels : item], []) : channel if channel != null && channel != ""]) > 0
  }
  enforcement_level = input.network-change-alert-enforcement-level
  enforce {
    condition     = !local.refs_vpc || (local.enabled_raw != false && local.has_channel)
    error_message = "An alert policy referencing a VPC network-change metric must be enabled and have a notification channel."
  }
}
