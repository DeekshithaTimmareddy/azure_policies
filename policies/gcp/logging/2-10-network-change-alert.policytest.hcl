# Copyright IBM Corp. 2026

policytest {
  targets = ["2-10-network-change-alert.policy.hcl"]
}

resource "google_logging_metric" "vpc_ok" {
  expect_failure = false
  attrs = {
    name              = "vpc-ok"
    filter            = "resource.type=\"gce_network\" AND (protoPayload.methodName:\"compute.networks.insert\" OR protoPayload.methodName:\"compute.networks.patch\" OR protoPayload.methodName:\"compute.networks.delete\" OR protoPayload.methodName:\"compute.networks.removePeering\" OR protoPayload.methodName:\"compute.networks.addPeering\")"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_vpc_ok" {
  expect_failure = false
  attrs = {
    display_name          = "alert-vpc-ok"
    combiner              = "OR"
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions            = [{ display_name = "cond-vpc-ok", condition_threshold = [{ comparison = "COMPARISON_GT", duration = "0s", threshold_value = 0, filter = "metric.type=\"logging.googleapis.com/user/vpc-ok\" AND resource.type=\"global\"" }] }]
  }
}

resource "google_logging_metric" "vpc_methods_combined_with_and" {
  expect_failure = true
  attrs = {
    name              = "vpc-methods-and"
    filter            = "resource.type=\"gce_network\" AND protoPayload.methodName:\"compute.networks.insert\" AND protoPayload.methodName:\"compute.networks.patch\" AND protoPayload.methodName:\"compute.networks.delete\" AND protoPayload.methodName:\"compute.networks.removePeering\" AND protoPayload.methodName:\"compute.networks.addPeering\""
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_vpc_methods_combined_with_and" {
  skip = true
  attrs = {
    display_name          = "alert-vpc-methods-and"
    combiner              = "OR"
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions            = [{ display_name = "cond-vpc-methods-and", condition_threshold = [{ comparison = "COMPARISON_GT", duration = "0s", threshold_value = 0, filter = "metric.type=\"logging.googleapis.com/user/vpc-methods-and\" AND resource.type=\"global\"" }] }]
  }
}

resource "google_logging_metric" "vpc_methods_negated" {
  expect_failure = true
  attrs = {
    name              = "vpc-methods-negated"
    filter            = "resource.type=\"gce_network\" AND NOT (protoPayload.methodName:\"compute.networks.insert\" OR protoPayload.methodName:\"compute.networks.patch\" OR protoPayload.methodName:\"compute.networks.delete\" OR protoPayload.methodName:\"compute.networks.removePeering\" OR protoPayload.methodName:\"compute.networks.addPeering\")"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_vpc_methods_negated" {
  expect_failure = true
  skip           = true
  attrs = {
    display_name          = "alert-vpc-methods-negated"
    combiner              = "OR"
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions            = [{ display_name = "cond-vpc-methods-negated", condition_threshold = [{ comparison = "COMPARISON_GT", duration = "0s", threshold_value = 0, filter = "metric.type=\"logging.googleapis.com/user/vpc-methods-negated\" AND resource.type=\"global\"" }] }]
  }
}

resource "google_logging_metric" "vpc_missing_channel" {
  expect_failure = true
  attrs = {
    name              = "vpc-missing-channel"
    filter            = "resource.type=\"gce_network\" AND (protoPayload.methodName:\"compute.networks.insert\" OR protoPayload.methodName:\"compute.networks.patch\" OR protoPayload.methodName:\"compute.networks.delete\" OR protoPayload.methodName:\"compute.networks.removePeering\" OR protoPayload.methodName:\"compute.networks.addPeering\")"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_vpc_missing_channel" {
  expect_failure = true
  skip           = true
  attrs = {
    display_name = "alert-vpc-missing-channel"
    combiner     = "OR"
    enabled      = true
    conditions   = [{ display_name = "cond-vpc-missing-channel", condition_threshold = [{ comparison = "COMPARISON_GT", duration = "0s", threshold_value = 0, filter = "metric.type=\"logging.googleapis.com/user/vpc-missing-channel\" AND resource.type=\"global\"" }] }]
  }
}

resource "google_logging_metric" "vpc_cli_ok" {
  expect_failure = false
  attrs = {
    name              = "vpc-cli-ok"
    filter            = "resource.type=\"gce_network\" AND protoPayload.methodName=\"beta.compute.networks.insert\" OR protoPayload.methodName=\"beta.compute.networks.patch\" OR protoPayload.methodName=\"v1.compute.networks.delete\" OR protoPayload.methodName=\"v1.compute.networks.removePeering\" OR protoPayload.methodName=\"v1.compute.networks.addPeering\""
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_vpc_cli_ok" {
  expect_failure = false
  attrs = {
    display_name          = "alert-vpc-cli-ok"
    combiner              = "OR"
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions            = [{ display_name = "cond-vpc-cli-ok", condition_threshold = [{ comparison = "COMPARISON_GT", duration = "0s", threshold_value = 0, filter = "metric.type=\"logging.googleapis.com/user/vpc-cli-ok\" AND resource.type=\"global\"" }] }]
  }
}

resource "google_logging_metric" "vpc_enabled_absent" {
  expect_failure = false
  attrs = {
    name              = "vpc-enabled-absent"
    filter            = "resource.type=\"gce_network\" AND (protoPayload.methodName:\"compute.networks.insert\" OR protoPayload.methodName:\"compute.networks.patch\" OR protoPayload.methodName:\"compute.networks.delete\" OR protoPayload.methodName:\"compute.networks.removePeering\" OR protoPayload.methodName:\"compute.networks.addPeering\")"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_vpc_enabled_absent" {
  expect_failure = false
  attrs = {
    display_name          = "alert-vpc-enabled-absent"
    combiner              = "OR"
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions            = [{ display_name = "cond-vpc-enabled-absent", condition_threshold = [{ comparison = "COMPARISON_GT", duration = "0s", threshold_value = 0, filter = "metric.type=\"logging.googleapis.com/user/vpc-enabled-absent\" AND resource.type=\"global\"" }] }]
  }
}

resource "google_logging_metric" "vpc_enabled_null" {
  expect_failure = false
  attrs = {
    name              = "vpc-enabled-null"
    filter            = "resource.type=\"gce_network\" AND (protoPayload.methodName:\"compute.networks.insert\" OR protoPayload.methodName:\"compute.networks.patch\" OR protoPayload.methodName:\"compute.networks.delete\" OR protoPayload.methodName:\"compute.networks.removePeering\" OR protoPayload.methodName:\"compute.networks.addPeering\")"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_vpc_enabled_null" {
  expect_failure = false
  attrs = {
    display_name          = "alert-vpc-enabled-null"
    combiner              = "OR"
    enabled               = null
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions            = [{ display_name = "cond-vpc-enabled-null", condition_threshold = [{ comparison = "COMPARISON_GT", duration = "0s", threshold_value = 0, filter = "metric.type=\"logging.googleapis.com/user/vpc-enabled-null\" AND resource.type=\"global\"" }] }]
  }
}

resource "google_logging_metric" "vpc_no_alert" {
  expect_failure = true
  attrs = {
    name              = "vpc-no-alert"
    filter            = "resource.type=\"gce_network\" AND (protoPayload.methodName:\"compute.networks.insert\" OR protoPayload.methodName:\"compute.networks.patch\" OR protoPayload.methodName:\"compute.networks.delete\" OR protoPayload.methodName:\"compute.networks.removePeering\" OR protoPayload.methodName:\"compute.networks.addPeering\")"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_logging_metric" "vpc_disabled_alert" {
  expect_failure = true
  attrs = {
    name              = "vpc-disabled-alert"
    filter            = "resource.type=\"gce_network\" AND (protoPayload.methodName:\"compute.networks.insert\" OR protoPayload.methodName:\"compute.networks.patch\" OR protoPayload.methodName:\"compute.networks.delete\" OR protoPayload.methodName:\"compute.networks.removePeering\" OR protoPayload.methodName:\"compute.networks.addPeering\")"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_vpc_disabled_alert" {
  expect_failure = true
  attrs = {
    display_name          = "alert-vpc-disabled-alert"
    combiner              = "OR"
    enabled               = false
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions            = [{ display_name = "cond-vpc-disabled-alert", condition_threshold = [{ comparison = "COMPARISON_GT", duration = "0s", threshold_value = 0, filter = "metric.type=\"logging.googleapis.com/user/vpc-disabled-alert\" AND resource.type=\"global\"" }] }]
  }
}

resource "google_logging_metric" "vpc_cli_disabled" {
  expect_failure = true
  attrs = {
    name              = "vpc-cli-disabled"
    filter            = "resource.type=\"gce_network\" AND protoPayload.methodName=\"beta.compute.networks.insert\" OR protoPayload.methodName=\"beta.compute.networks.patch\" OR protoPayload.methodName=\"v1.compute.networks.delete\" OR protoPayload.methodName=\"v1.compute.networks.removePeering\" OR protoPayload.methodName=\"v1.compute.networks.addPeering\""
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_vpc_cli_disabled" {
  expect_failure = true
  attrs = {
    display_name          = "alert-vpc-cli-disabled"
    combiner              = "OR"
    enabled               = false
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions            = [{ display_name = "cond-vpc-cli-disabled", condition_threshold = [{ comparison = "COMPARISON_GT", duration = "0s", threshold_value = 0, filter = "metric.type=\"logging.googleapis.com/user/vpc-cli-disabled\" AND resource.type=\"global\"" }] }]
  }
}

resource "google_logging_metric" "vpc_wrong_ref" {
  expect_failure = true
  attrs = {
    name              = "vpc-wrong-ref"
    filter            = "resource.type=\"gce_network\" AND (protoPayload.methodName:\"compute.networks.insert\" OR protoPayload.methodName:\"compute.networks.patch\" OR protoPayload.methodName:\"compute.networks.delete\" OR protoPayload.methodName:\"compute.networks.removePeering\" OR protoPayload.methodName:\"compute.networks.addPeering\")"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_vpc_wrong_ref" {
  expect_failure = false
  attrs = {
    display_name          = "alert-vpc-wrong-ref"
    combiner              = "OR"
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions            = [{ display_name = "cond-vpc-wrong-ref", condition_threshold = [{ comparison = "COMPARISON_GT", duration = "0s", threshold_value = 0, filter = "metric.type=\"logging.googleapis.com/user/other-metric-wrong-ref\" AND resource.type=\"global\"" }] }]
  }
}

resource "google_logging_metric" "vpc_partial" {
  expect_failure = true
  attrs = {
    name              = "vpc-partial"
    filter            = "resource.type=\"gce_network\" AND (protoPayload.methodName:\"compute.networks.insert\" OR protoPayload.methodName:\"compute.networks.patch\")"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_vpc_partial" {
  expect_failure = false
  attrs = {
    display_name          = "alert-vpc-partial"
    combiner              = "OR"
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions            = [{ display_name = "cond-vpc-partial", condition_threshold = [{ comparison = "COMPARISON_GT", duration = "0s", threshold_value = 0, filter = "metric.type=\"logging.googleapis.com/user/vpc-partial\" AND resource.type=\"global\"" }] }]
  }
}

resource "google_logging_metric" "vpc_wrong_type" {
  expect_failure = true
  attrs = {
    name              = "vpc-wrong-type"
    filter            = "resource.type=\"gce_instance\" AND (protoPayload.methodName:\"compute.networks.insert\" OR protoPayload.methodName:\"compute.networks.patch\" OR protoPayload.methodName:\"compute.networks.delete\" OR protoPayload.methodName:\"compute.networks.removePeering\" OR protoPayload.methodName:\"compute.networks.addPeering\")"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_vpc_wrong_type" {
  expect_failure = false
  attrs = {
    display_name          = "alert-vpc-wrong-type"
    combiner              = "OR"
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions            = [{ display_name = "cond-vpc-wrong-type", condition_threshold = [{ comparison = "COMPARISON_GT", duration = "0s", threshold_value = 0, filter = "metric.type=\"logging.googleapis.com/user/vpc-wrong-type\" AND resource.type=\"global\"" }] }]
  }
}

resource "google_logging_metric" "vpc_empty_filter" {
  expect_failure = true
  attrs = {
    name              = "vpc-empty-filter"
    filter            = ""
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_vpc_empty_filter" {
  expect_failure = false
  attrs = {
    display_name          = "alert-vpc-empty-filter"
    combiner              = "OR"
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions            = [{ display_name = "cond-vpc-empty-filter", condition_threshold = [{ comparison = "COMPARISON_GT", duration = "0s", threshold_value = 0, filter = "metric.type=\"logging.googleapis.com/user/vpc-empty-filter\" AND resource.type=\"global\"" }] }]
  }
}
