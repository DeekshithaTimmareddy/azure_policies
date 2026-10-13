# Copyright IBM Corp. 2026

# Ensure That the Log Metric Filter and Alerts Exist for Cloud Storage IAM Permission Changes

policy {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0.0, < 8.0.0"
    }
  }
}

input "storage-iam-alert-enforcement-level" {
  type    = string
  default = "advisory"
}

locals {
  storage_iam_metrics  = core::try([for m in core::getresources("google_logging_metric", {}) : m], [])
  storage_iam_policies = core::try([for p in core::getresources("google_monitoring_alert_policy", {}) : p], [])

  prescribed_storage_iam_filter = "^\\s*\\(?\\s*(resource\\.type\\s*=\\s*\"?gcs_bucket\"?\\s+AND\\s+protoPayload\\.methodName\\s*=\\s*\"storage\\.setIamPermissions\"|protoPayload\\.methodName\\s*=\\s*\"storage\\.setIamPermissions\"\\s+AND\\s+resource\\.type\\s*=\\s*\"?gcs_bucket\"?)\\s*\\)?\\s*$"

  matching_storage_iam_metric_names = [
    for metric in local.storage_iam_metrics : core::try(metric.name, "")
    if core::try(metric.name, null) != null && core::try(metric.name, "") != "" && core::try(core::regex(local.prescribed_storage_iam_filter, core::try(metric.filter, null) == null ? "" : metric.filter), null) != null
  ]

  eligible_storage_iam_policies = [
    for policy in local.storage_iam_policies : policy
    if core::try(policy.enabled, null) != false && core::length([for channel in core::try([for item in policy.notification_channels : item], []) : channel if channel != null && channel != ""]) > 0
  ]

  alerted_storage_iam_metric_names = [
    for name in local.matching_storage_iam_metric_names : name
    if core::length([for policy in local.eligible_storage_iam_policies : policy if core::length([for condition in core::try([for item in policy.conditions : item], []) : condition if core::length([for threshold in core::try([for item in condition.condition_threshold : item], []) : threshold if (core::length(core::split("logging.googleapis.com/user/${name}\"", core::try(threshold.filter, ""))) > 1 || core::length(core::split("logging.googleapis.com/user/${name}\\\"", core::try(threshold.filter, ""))) > 1 || core::length(core::split("logging.googleapis.com/user/${name} ", core::try(threshold.filter, ""))) > 1 || core::endswith(core::try(threshold.filter, ""), "logging.googleapis.com/user/${name}"))]) > 0]) > 0]) > 0
  ]

  storage_iam_control_compliant = core::length(local.matching_storage_iam_metric_names) > 0 && core::length(local.alerted_storage_iam_metric_names) > 0
}

resource_policy "google_logging_metric" "gcs_iam_change_metric_and_alert" {
  filter = core::try(core::contains_substring(attrs.filter, "gcs_bucket"), false) || core::try(core::contains_substring(attrs.filter, "storage.setIamPermissions"), false)

  enforcement_level = input.storage-iam-alert-enforcement-level
  enforce {
    condition     = local.storage_iam_control_compliant
    error_message = "At least one Cloud Storage IAM-change log metric must be referenced by an enabled alert policy condition threshold with a notification channel."
  }
}

resource_policy "google_monitoring_alert_policy" "gcs_iam_change_metric_and_alert" {
  locals {
    filters = core::flatten([for condition in core::try([for item in attrs.conditions : item], []) : [for threshold in core::try([for item in condition.condition_threshold : item], []) : core::try(threshold.filter, "")]])
    references_storage_iam_metric = core::length([for name in local.matching_storage_iam_metric_names : name if name != "" && core::length([for filter in local.filters : filter if core::try(core::regex("logging\\.googleapis\\.com/user/${name}([^A-Za-z0-9_./-]|$)", filter), null) != null]) > 0]) > 0
  }
  filter = local.references_storage_iam_metric

  enforcement_level = input.storage-iam-alert-enforcement-level
  enforce {
    condition     = local.storage_iam_control_compliant
    error_message = "An enabled alert with a notification channel must reference a Cloud Storage IAM-change log metric."
  }
}
