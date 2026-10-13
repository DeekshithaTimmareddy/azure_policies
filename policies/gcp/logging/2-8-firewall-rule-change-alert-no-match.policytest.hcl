# Copyright IBM Corp. 2026

policytest {
  targets = ["2-8-firewall-rule-change-alert.policy.hcl"]
}

resource "google_logging_metric" "fail_negated_methods_with_alert" {
  expect_failure = true
  attrs = {
    name   = "fw-negated-linked"
    filter = "resource.type=\"gce_firewall_rule\" AND (NOT protoPayload.methodName:\"compute.firewalls.patch\" OR NOT protoPayload.methodName:\"compute.firewalls.insert\" OR NOT protoPayload.methodName:\"compute.firewalls.delete\")"
  }
}

resource "google_monitoring_alert_policy" "alert_for_negated_methods" {
  skip = true
  attrs = {
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{ condition_threshold = [{
      filter = "metric.type=\"logging.googleapis.com/user/fw-negated-linked\" AND resource.type=\"global\""
    }] }]
  }
}

resource "google_logging_metric" "fail_methods_combined_with_and" {
  expect_failure = true
  attrs = {
    name              = "fw-methods-and"
    filter            = "resource.type=\"gce_firewall_rule\" AND protoPayload.methodName:\"compute.firewalls.patch\" AND protoPayload.methodName:\"compute.firewalls.insert\" AND protoPayload.methodName:\"compute.firewalls.delete\""
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_methods_combined_with_and" {
  expect_failure = true
  skip           = true
  attrs = {
    display_name          = "alert-fw-methods-and"
    combiner              = "OR"
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{
      display_name = "firewall-changes"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/fw-methods-and\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
      }]
    }]
  }
}

resource "google_logging_metric" "fail_missing_delete" {
  expect_failure = true
  attrs = {
    name   = "fw-missing-delete"
    filter = "resource.type=\"gce_firewall_rule\" AND (protoPayload.methodName:\"compute.firewalls.patch\" OR protoPayload.methodName:\"compute.firewalls.insert\")"
  }
}

resource "google_monitoring_alert_policy" "alert_missing_delete" {
  expect_failure = true
  skip           = true
  attrs = {
    display_name          = "alert-missing-delete"
    combiner              = "OR"
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{
      display_name = "firewall-changes"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/fw-missing-delete\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
      }]
    }]
  }
}

resource "google_logging_metric" "fail_wrong_resource_type" {
  expect_failure = true
  attrs = {
    name   = "fw-wrong-resource"
    filter = "resource.type=\"gce_instance\" AND (protoPayload.methodName:\"compute.firewalls.patch\" OR protoPayload.methodName:\"compute.firewalls.insert\" OR protoPayload.methodName:\"compute.firewalls.delete\")"
  }
}

resource "google_monitoring_alert_policy" "alert_wrong_resource_type" {
  expect_failure = true
  skip           = true
  attrs = {
    display_name          = "alert-wrong-resource"
    combiner              = "OR"
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{
      display_name = "firewall-changes"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/fw-wrong-resource\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
      }]
    }]
  }
}

resource "google_logging_metric" "fail_empty_filter" {
  expect_failure = true
  attrs = {
    name   = "fw-empty-filter"
    filter = "resource.type=\"gce_firewall_rule\""
  }
}

resource "google_logging_metric" "fail_no_alert" {
  expect_failure = true
  attrs = {
    name   = "fw-no-alert"
    filter = "resource.type=\"gce_firewall_rule\" AND (protoPayload.methodName:\"compute.firewalls.patch\" OR protoPayload.methodName:\"compute.firewalls.insert\" OR protoPayload.methodName:\"compute.firewalls.delete\")"
  }
}

resource "google_logging_metric" "fail_disabled_alert" {
  expect_failure = true
  attrs = {
    name   = "fw-disabled-alert"
    filter = "resource.type=\"gce_firewall_rule\" AND (protoPayload.methodName:\"compute.firewalls.patch\" OR protoPayload.methodName:\"compute.firewalls.insert\" OR protoPayload.methodName:\"compute.firewalls.delete\")"
  }
}

resource "google_monitoring_alert_policy" "alert_disabled" {
  expect_failure = true
  skip           = true
  attrs = {
    display_name          = "alert-disabled"
    combiner              = "OR"
    enabled               = false
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{
      display_name = "firewall-changes"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/fw-disabled-alert\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
      }]
    }]
  }
}

resource "google_logging_metric" "fail_wrong_alert_reference" {
  expect_failure = true
  attrs = {
    name   = "fw-wrong-alert-reference"
    filter = "resource.type=\"gce_firewall_rule\" AND (protoPayload.methodName:\"compute.firewalls.patch\" OR protoPayload.methodName:\"compute.firewalls.insert\" OR protoPayload.methodName:\"compute.firewalls.delete\")"
  }
}

resource "google_monitoring_alert_policy" "alert_wrong_reference" {
  expect_failure = true
  skip           = true
  attrs = {
    display_name          = "alert-wrong-reference"
    combiner              = "OR"
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{
      display_name = "firewall-changes"
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
    name   = "fw-no-channel"
    filter = "resource.type=\"gce_firewall_rule\" AND (protoPayload.methodName:\"compute.firewalls.patch\" OR protoPayload.methodName:\"compute.firewalls.insert\" OR protoPayload.methodName:\"compute.firewalls.delete\")"
  }
}

resource "google_monitoring_alert_policy" "alert_missing_notification_channel" {
  expect_failure = true
  skip           = true
  attrs = {
    display_name = "alert-no-channel"
    combiner     = "OR"
    enabled      = true
    conditions = [{
      display_name = "firewall-changes"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/fw-no-channel\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
      }]
    }]
  }
}
