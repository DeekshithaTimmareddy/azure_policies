# Copyright IBM Corp. 2026

policytest {
  targets = ["2-12-sql-config-change-alert.policy.hcl"]
}

resource "google_logging_metric" "fail_no_alert" {
  expect_failure = true
  attrs = {
    name   = "sql-no-alert"
    filter = "protoPayload.methodName=\"cloudsql.instances.update\""
  }
}

resource "google_logging_metric" "fail_wrong_method" {
  expect_failure = true
  attrs = {
    name   = "sql-wrong-method"
    filter = "protoPayload.methodName=\"cloudsql.instances.create\""
  }
}

resource "google_logging_metric" "fail_wrong_alert_reference" {
  expect_failure = true
  attrs = {
    name   = "sql-wrong-alert-reference"
    filter = "protoPayload.methodName=\"cloudsql.instances.update\""
  }
}

resource "google_monitoring_alert_policy" "wrong_alert_reference" {
  skip = true
  attrs = {
    display_name = "sql-wrong-alert-reference"
    combiner     = "OR"
    enabled      = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{
      display_name = "sql-change"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/some-other-metric\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
      }]
    }]
  }
}

resource "google_logging_metric" "fail_disabled_alert" {
  expect_failure = true
  attrs = {
    name   = "sql-disabled-alert"
    filter = "protoPayload.methodName=\"cloudsql.instances.update\""
  }
}

resource "google_monitoring_alert_policy" "disabled_alert" {
  skip = true
  attrs = {
    display_name = "sql-disabled-alert"
    combiner     = "OR"
    enabled      = false
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{
      display_name = "sql-change"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/sql-disabled-alert\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
      }]
    }]
  }
}

resource "google_logging_metric" "fail_no_notification_channel" {
  expect_failure = true
  attrs = {
    name   = "sql-no-channel"
    filter = "protoPayload.methodName=\"cloudsql.instances.update\""
  }
}

resource "google_monitoring_alert_policy" "no_notification_channel" {
  skip = true
  attrs = {
    display_name = "sql-no-channel"
    combiner     = "OR"
    enabled      = true
    conditions = [{
      display_name = "sql-change"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/sql-no-channel\" AND resource.type=\"global\""
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
    name   = "sql-absent-only"
    filter = "protoPayload.methodName=\"cloudsql.instances.update\""
  }
}

resource "google_monitoring_alert_policy" "absent_condition_only" {
  skip = true
  attrs = {
    display_name = "sql-absent-only"
    combiner     = "OR"
    enabled      = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{
      display_name = "sql-change-absent"
      condition_absent = [{
        filter   = "metric.type=\"logging.googleapis.com/user/sql-absent-only\" AND resource.type=\"global\""
        duration = "0s"
      }]
    }]
  }
}
