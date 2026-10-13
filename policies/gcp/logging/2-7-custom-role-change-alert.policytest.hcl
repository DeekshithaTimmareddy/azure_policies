# Copyright IBM Corp. 2026

policytest {
  targets = ["2-7-custom-role-change-alert.policy.hcl"]
}

resource "google_logging_metric" "pass_full_filter_enabled_alert" {
  attrs = {
    name   = "pass-full-filter-enabled-alert"
    filter = "resource.type=\"iam_role\" AND (protoPayload.methodName=\"google.iam.admin.v1.CreateRole\" OR protoPayload.methodName=\"google.iam.admin.v1.DeleteRole\" OR protoPayload.methodName=\"google.iam.admin.v1.UpdateRole\" OR protoPayload.methodName=\"google.iam.admin.v1.UndeleteRole\")"
    metric_descriptor = [{
      metric_kind = "DELTA"
      value_type  = "INT64"
      unit        = "1"
    }]
  }
}

resource "google_monitoring_alert_policy" "alert_pass_full_filter_enabled_alert" {
  skip = true
  attrs = {
    display_name          = "alert-pass-full-filter-enabled-alert"
    combiner              = "OR"
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{
      display_name = "cond-0"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/pass-full-filter-enabled-alert\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        duration        = "0s"
        threshold_value = 0
      }]
    }]
  }
}

resource "google_logging_metric" "fail_methods_combined_with_and" {
  expect_failure = true
  attrs = {
    name              = "fail-methods-and"
    filter            = "resource.type=\"iam_role\" AND protoPayload.methodName=\"google.iam.admin.v1.CreateRole\" AND protoPayload.methodName=\"google.iam.admin.v1.DeleteRole\" AND protoPayload.methodName=\"google.iam.admin.v1.UpdateRole\" AND protoPayload.methodName=\"google.iam.admin.v1.UndeleteRole\""
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_fail_methods_combined_with_and" {
  skip = true
  attrs = {
    display_name = "alert-fail-methods-and"
    combiner     = "OR"
    enabled      = true
    conditions = [{
      display_name = "custom-role-changes"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/fail-methods-and\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        duration        = "0s"
        threshold_value = 0
      }]
    }]
  }
}
