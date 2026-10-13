# Copyright IBM Corp. 2026

# Ensure That the Log Metric Filter and Alerts Exist for VPC Network Route Changes

policy {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0.0, < 8.0.0"
    }
  }
}

input "route-change-alert-enforcement-level" {
  type    = string
  default = "advisory"
}

locals {
  route_change_alert_policies = core::try(core::getresources("google_monitoring_alert_policy", {}), [])
}

resource_policy "google_logging_metric" "route_change_metric_has_alert" {
  locals {
    filter_raw  = core::try(attrs.filter, null)
    filter_text = local.filter_raw == null ? "" : local.filter_raw
    name_raw    = core::try(attrs.name, null)
    metric_name = local.name_raw == null ? "" : local.name_raw

    is_route_metric = core::try(core::regex("resource\\.type\\s*=\\s*\"gce_route\"", local.filter_text), null) != null

    or_del_ins = core::try(core::regex("\\(\\s*protoPayload\\.methodName\\s*:\\s*\"compute\\.routes\\.delete\"\\s+OR\\s+protoPayload\\.methodName\\s*:\\s*\"compute\\.routes\\.insert\"\\s*\\)", local.filter_text), null) != null
    or_ins_del = core::try(core::regex("\\(\\s*protoPayload\\.methodName\\s*:\\s*\"compute\\.routes\\.insert\"\\s+OR\\s+protoPayload\\.methodName\\s*:\\s*\"compute\\.routes\\.delete\"\\s*\\)", local.filter_text), null) != null
    has_or     = local.or_del_ins || local.or_ins_del
    rt_and     = core::try(core::regex("resource\\.type\\s*=\\s*\"gce_route\"\\s+AND\\s+\\(", local.filter_text), null) != null
    negated    = core::try(core::regex("(^|[\\s(])(NOT\\s|-\\s*protoPayload|-\\s*resource|!)", local.filter_text), null) != null

    metric_type = "logging.googleapis.com/user/${local.metric_name}"
    mt_quote    = "${local.metric_type}\""
    mt_esc      = "${local.metric_type}\\\""
    mt_space    = "${local.metric_type} "
    mt_paren    = "${local.metric_type})"

    cond_texts = core::flatten([
      for p in local.route_change_alert_policies : [
        for c in core::try([for x in p.conditions : x], []) : [
          for threshold in core::try([for t in c.condition_threshold : t], []) : core::try(threshold.filter, "")
        ]
      ] if core::try(p.enabled, null) != false
    ])

    matching_alerts = [
      for filter_text in local.cond_texts : filter_text
      if core::try(core::contains_substring(filter_text, local.mt_quote), false) || core::try(core::contains_substring(filter_text, local.mt_esc), false) || core::try(core::contains_substring(filter_text, local.mt_space), false) || core::try(core::contains_substring(filter_text, local.mt_paren), false) || filter_text == local.metric_type
    ]
  }

  filter = local.is_route_metric

  enforcement_level = input.route-change-alert-enforcement-level

  enforce {
    condition     = local.has_or && local.rt_and && !local.negated && local.metric_name != "" && core::length(local.matching_alerts) > 0
    error_message = "VPC route-change log metric '${local.metric_name}' must cover route insert and delete events without negation and be referenced by an enabled alert condition threshold."
  }
}
