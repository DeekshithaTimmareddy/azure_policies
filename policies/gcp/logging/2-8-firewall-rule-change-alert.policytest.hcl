# Copyright IBM Corp. 2026

policytest {
  targets = ["2-8-firewall-rule-change-alert.policy.hcl"]
}

resource "google_logging_metric" "fw-s1" {
  attrs = {
    name              = "fw-s1"
    filter            = "resource.type=\"gce_firewall_rule\" AND (protoPayload.methodName:\"compute.firewalls.patch\" OR protoPayload.methodName:\"compute.firewalls.insert\" OR protoPayload.methodName:\"compute.firewalls.delete\")"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert-s1" {
  attrs = {
    display_name          = "alert-s1"
    combiner              = "OR"
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{
      display_name = "alert-s1-cond"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/fw-s1\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
        aggregations    = [{ alignment_period = "60s", per_series_aligner = "ALIGN_COUNT" }]
      }]
    }]
  }
}

resource "google_logging_metric" "fw-s2-reordered" {
  attrs = {
    name   = "fw-s2-reordered"
    filter = "resource.type=\"gce_firewall_rule\" AND (protoPayload.methodName:\"compute.firewalls.delete\" OR protoPayload.methodName:\"compute.firewalls.patch\" OR protoPayload.methodName:\"compute.firewalls.insert\")"
    metric_descriptor = [{
      metric_kind = "DELTA"
      value_type  = "INT64"
      unit        = "1"
    }]
  }
}

resource "google_monitoring_alert_policy" "alert-s2-reordered" {
  skip = true
  attrs = {
    display_name          = "alert-s2-reordered"
    combiner              = "OR"
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{
      display_name = "alert-s2-reordered-cond"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/fw-s2-reordered\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
      }]
    }]
  }
}
