# Copyright IBM Corp. 2026

# Ensure Log Metric Filter and Alerts Exist for Project Ownership Assignments and Changes

policy {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0.0, < 8.0.0"
    }
  }
}

input "project-ownership-alert-enforcement-level" {
  type    = string
  default = "advisory"
}

locals {
  project_ownership_alert_policies = core::try([for p in core::getresources("google_monitoring_alert_policy", {}) : p], [])
  enabled_ownership_alert_policies = [for p in local.project_ownership_alert_policies : p if core::try(p.enabled, null) != false]
}

resource_policy "google_logging_metric" "project_ownership_metric_and_alert" {
  locals {
    filter_raw = core::try(attrs.filter, null)
    filter     = local.filter_raw == null ? "" : local.filter_raw
    name_raw   = core::try(attrs.name, null)
    name       = local.name_raw == null ? "" : local.name_raw

    has_service   = core::try(core::regex("protoPayload\\.serviceName\\s*=\\s*\"cloudresourcemanager\\.googleapis\\.com\"", local.filter), null) != null
    has_ownership = core::try(core::regex("ProjectOwnership", local.filter), null) != null
    has_invitee   = core::try(core::regex("projectOwnerInvitee", local.filter), null) != null
    add_owner_a   = core::try(core::regex("bindingDeltas\\.action\\s*=\\s*\"ADD\"\\s+AND\\s+protoPayload\\.serviceData\\.policyDelta\\.bindingDeltas\\.role\\s*=\\s*\"roles/owner\"", local.filter), null) != null
    add_owner_b   = core::try(core::regex("bindingDeltas\\.role\\s*=\\s*\"roles/owner\"\\s+AND\\s+protoPayload\\.serviceData\\.policyDelta\\.bindingDeltas\\.action\\s*=\\s*\"ADD\"", local.filter), null) != null
    rem_owner_a   = core::try(core::regex("bindingDeltas\\.action\\s*=\\s*\"REMOVE\"\\s+AND\\s+protoPayload\\.serviceData\\.policyDelta\\.bindingDeltas\\.role\\s*=\\s*\"roles/owner\"", local.filter), null) != null
    rem_owner_b   = core::try(core::regex("bindingDeltas\\.role\\s*=\\s*\"roles/owner\"\\s+AND\\s+protoPayload\\.serviceData\\.policyDelta\\.bindingDeltas\\.action\\s*=\\s*\"REMOVE\"", local.filter), null) != null
    filter_ok     = local.has_service && local.has_ownership && local.has_invitee && (local.add_owner_a || local.add_owner_b) && (local.rem_owner_a || local.rem_owner_b)

    metric_type     = "logging.googleapis.com/user/${local.name}"
    matching_alerts = [for p in local.enabled_ownership_alert_policies : p if local.name != "" && core::length([for c in core::try([for x in p.conditions : x], []) : c if core::length([for t in core::try([for y in c.condition_threshold : y], []) : t if core::try(core::contains_substring(t.filter, "${local.metric_type}\""), false) || core::try(core::contains_substring(t.filter, "${local.metric_type} "), false) || core::try(core::endswith(t.filter, local.metric_type), false)]) > 0]) > 0]
    alert_ok        = core::length(local.matching_alerts) > 0
  }

  filter = core::try(core::contains_substring(attrs.filter, "roles/owner"), false) || core::try(core::contains_substring(attrs.filter, "ProjectOwnership"), false) || core::try(core::contains_substring(attrs.filter, "projectOwnerInvitee"), false) || core::try(core::contains_substring(attrs.filter, "cloudresourcemanager.googleapis.com"), false)

  enforcement_level = input.project-ownership-alert-enforcement-level

  enforce {
    condition     = local.filter_ok && local.alert_ok
    error_message = "Project-ownership log metric '${local.name}' must use the prescribed filter and be referenced by an enabled google_monitoring_alert_policy condition_threshold filter."
  }
}
