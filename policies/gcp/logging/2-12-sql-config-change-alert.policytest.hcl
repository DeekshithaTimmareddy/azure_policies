# Copyright IBM Corp. 2026

policytest {
  targets = ["2-12-sql-config-change-alert.policy.hcl"]
}

resource "google_logging_metric" "pass_prescribed_metric" {
  attrs = {
    name              = "sqlcfg-s1"
    filter            = "protoPayload.methodName=\"cloudsql.instances.update\""
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}
resource "google_monitoring_alert_policy" "pass_enabled_alert" {
  attrs = {
    display_name          = "pass_enabled_alert"
    combiner              = "OR"
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{
      display_name = "sql-instance-config-change"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/sqlcfg-s1\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
      }]
    }]
  }
}

resource "google_logging_metric" "pass_enabled_default" {
  attrs = {
    name   = "sqlcfg-default-enabled"
    filter = "protoPayload.methodName=\"cloudsql.instances.update\""
    metric_descriptor = [{
      metric_kind = "DELTA"
      value_type  = "INT64"
      unit        = "1"
    }]
  }
}

resource "google_monitoring_alert_policy" "pass_enabled_default" {
  skip = true
  attrs = {
    display_name          = "pass_enabled_default"
    combiner              = "OR"
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{
      display_name = "sql-instance-config-change"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/sqlcfg-default-enabled\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
      }]
    }]
  }
}

resource "google_logging_metric" "pass_alert_second_condition" {
  attrs = {
    name   = "sqlcfg-second-condition"
    filter = "protoPayload.methodName=\"cloudsql.instances.update\""
    metric_descriptor = [{
      metric_kind = "DELTA"
      value_type  = "INT64"
      unit        = "1"
    }]
  }
}

resource "google_monitoring_alert_policy" "pass_alert_second_condition" {
  skip = true
  attrs = {
    display_name          = "pass_alert_second_condition"
    combiner              = "OR"
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [
      {
        display_name = "unrelated"
        condition_threshold = [{
          filter          = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" AND resource.type=\"gce_instance\""
          comparison      = "COMPARISON_GT"
          threshold_value = 0.9
          duration        = "60s"
        }]
      },
      {
        display_name = "sql-instance-config-change"
        condition_threshold = [{
          filter          = "metric.type=\"logging.googleapis.com/user/sqlcfg-second-condition\" AND resource.type=\"global\""
          comparison      = "COMPARISON_GT"
          threshold_value = 0
          duration        = "0s"
        }]
      }
    ]
  }
}
