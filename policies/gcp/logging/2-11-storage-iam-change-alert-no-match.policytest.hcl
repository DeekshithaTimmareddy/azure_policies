# Copyright IBM Corp. 2026

policytest {
  targets = ["2-11-storage-iam-change-alert.policy.hcl"]
}

resource "google_logging_metric" "fail_f2_no_alert" {
  expect_failure = true
  attrs = {
    name   = "fail_f2_no_alert"
    filter = "resource.type=\"gcs_bucket\" AND protoPayload.methodName=\"storage.setIamPermissions\""
  }
}

resource "google_logging_metric" "fail_f3_alert_disabled" {
  expect_failure = true
  attrs = {
    name   = "fail_f3_alert_disabled"
    filter = "resource.type=\"gcs_bucket\" AND protoPayload.methodName=\"storage.setIamPermissions\""
  }
}

resource "google_monitoring_alert_policy" "alert_f3" {
  expect_failure = true
  skip = true
  attrs = {
    display_name = "alert_f3"
    combiner     = "OR"
    enabled      = false
    conditions = [{
      display_name = "c-alert_f3"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/fail_f3_alert_disabled\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
      }]
    }]
  }
}

resource "google_logging_metric" "fail_f5_alert_other_metric" {
  expect_failure = true
  attrs = {
    name   = "fail_f5_alert_other_metric"
    filter = "resource.type=\"gcs_bucket\" AND protoPayload.methodName=\"storage.setIamPermissions\""
  }
}

resource "google_monitoring_alert_policy" "alert_f5_other_metric" {
  expect_failure = true
  skip = true
  attrs = {
    display_name = "alert_f5_other_metric"
    combiner     = "OR"
    enabled      = true
    conditions = [{
      display_name = "c-alert_f5_other_metric"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/some-other-metric\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
      }]
    }]
  }
}

resource "google_logging_metric" "fail_missing_notification_channel" {
  expect_failure = true
  attrs = {
    name   = "fail_f7_no_channel"
    filter = "resource.type=\"gcs_bucket\" AND protoPayload.methodName=\"storage.setIamPermissions\""
  }
}

resource "google_monitoring_alert_policy" "alert_missing_notification_channel" {
  expect_failure = true
  skip = true
  attrs = {
    display_name = "alert-f7-no-channel"
    combiner     = "OR"
    enabled      = true
    conditions = [{
      display_name = "c-alert-f7-no-channel"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/fail_f7_no_channel\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
      }]
    }]
  }
}

resource "google_logging_metric" "fail_absent_condition_only" {
  expect_failure = true
  attrs = {
    name   = "fail_f9-absent-only"
    filter = "resource.type=\"gcs_bucket\" AND protoPayload.methodName=\"storage.setIamPermissions\""
  }
}

resource "google_monitoring_alert_policy" "alert_absent_condition_only" {
  expect_failure = true
  skip = true
  attrs = {
    display_name = "alert-f9-absent-only"
    combiner     = "OR"
    enabled      = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{
      display_name = "c-alert-f9-absent-only"
      condition_absent = [{
        filter   = "metric.type=\"logging.googleapis.com/user/fail_f9-absent-only\" AND resource.type=\"global\""
        duration = "0s"
      }]
    }]
  }
}
