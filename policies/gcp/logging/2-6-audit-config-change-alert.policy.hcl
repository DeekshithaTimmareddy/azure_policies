# Copyright IBM Corp. 2026

# Ensure That the Log Metric Filter and Alerts Exist for Audit Configuration Changes

policy {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0.0, < 8.0.0"
    }
  }
}

input "audit-config-alert-enforcement-level" {
  type    = string
  default = "advisory"
}

locals {
  audit_config_alert_policies = core::getresources("google_monitoring_alert_policy", {})

  audit_config_alert_filters = core::flatten([
    for p in local.audit_config_alert_policies : [
      for c in core::try([for x in p.conditions : x], []) : [
        for t in core::try([for y in c.condition_threshold : y], []) : core::try(t.filter, null) == null ? "" : t.filter
      ]
    ] if core::try(p.enabled, null) != false
  ])
}

resource_policy "google_logging_metric" "audit_config_change_metric_alert" {
  locals {
    filter_raw = core::try(attrs.filter, null)
    filter     = local.filter_raw == null ? "" : local.filter_raw
    name_raw   = core::try(attrs.name, null)
    name       = local.name_raw == null ? "" : local.name_raw

    fwd       = "^\\s*protoPayload\\.methodName\\s*=\\s*\"SetIamPolicy\"\\s+AND\\s+protoPayload\\.serviceData\\.policyDelta\\.auditConfigDeltas\\s*:\\s*\\*\\s*$"
    rev       = "^\\s*protoPayload\\.serviceData\\.policyDelta\\.auditConfigDeltas\\s*:\\s*\\*\\s+AND\\s+protoPayload\\.methodName\\s*=\\s*\"SetIamPolicy\"\\s*$"
    filter_ok = core::try(core::regex(local.fwd, local.filter), null) != null || core::try(core::regex(local.rev, local.filter), null) != null
    in_scope  = core::try(core::contains_substring(local.filter, "SetIamPolicy"), false) || core::try(core::contains_substring(local.filter, "auditConfigDeltas"), false)

    metric_type = "logging.googleapis.com/user/${local.name}"
    matching_alerts = [
      for f in local.audit_config_alert_filters : f
      if local.name != "" && (core::contains_substring(f, "${local.metric_type}\"") || core::contains_substring(f, "${local.metric_type} ") || core::contains_substring(f, "${local.metric_type}\n") || core::contains_substring(f, "${local.metric_type}\t") || core::endswith(f, local.metric_type))
    ]
  }

  filter = local.in_scope

  enforcement_level = input.audit-config-alert-enforcement-level

  enforce {
    condition     = local.filter_ok && core::length(local.matching_alerts) > 0
    error_message = "Audit-configuration log metric '${local.name}' must use the prescribed SetIamPolicy and auditConfigDeltas filter and be referenced by an enabled google_monitoring_alert_policy condition_threshold filter."
  }
}
