# Copyright IBM Corp. 2026

policytest {
  targets = ["2-11-storage-iam-change-alert.policy.hcl"]
}

resource "google_logging_metric" "pass_f1_compliant" {
  attrs = {
    name              = "pass_f1_compliant"
    filter            = "resource.type=\"gcs_bucket\" AND protoPayload.methodName=\"storage.setIamPermissions\""
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_f1" {
  attrs = {
    display_name          = "alert_f1"
    combiner              = "OR"
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{
      display_name = "c-alert_f1"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/pass_f1_compliant\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
      }]
    }]
  }
}

resource "google_logging_metric" "pass_f4_enabled_default" {
  attrs = {
    name              = "pass_f4_enabled_default"
    filter            = "resource.type=\"gcs_bucket\" AND protoPayload.methodName=\"storage.setIamPermissions\""
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_f4" {
  attrs = {
    display_name          = "alert_f4"
    combiner              = "OR"
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]

    conditions = [{
      display_name = "c-alert_f4"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/pass_f4_enabled_default\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
      }]
    }]
  }
}

resource "google_logging_metric" "pass_f8_cli_form" {
  attrs = {
    name              = "pass_f8_cli_form"
    filter            = "resource.type=gcs_bucket AND protoPayload.methodName=\"storage.setIamPermissions\""
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_f8" {
  attrs = {
    display_name          = "alert_f8"
    combiner              = "OR"
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{
      display_name = "c-alert_f8"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/pass_f8_cli_form\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
      }]
    }]
  }
}

resource "google_logging_metric" "pass_f6_some_conditions" {
  attrs = {
    name              = "pass_f6_some_conditions"
    filter            = "resource.type=\"gcs_bucket\" AND protoPayload.methodName=\"storage.setIamPermissions\""
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_f6" {
  attrs = {
    display_name          = "alert_f6"
    combiner              = "OR"
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{
      display_name = "c6a"
      condition_threshold = [{
        filter          = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" AND resource.type=\"gce_instance\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0.9
        duration        = "60s"
      }]
      }, {
      display_name = "c6b"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/pass_f6_some_conditions\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
      }]
    }]
  }
}

resource "google_logging_metric" "unrelated_metric_out_of_scope" {
  attrs = {
    name              = "unrelated_metric_out_of_scope"
    filter            = "resource.type=\"gce_instance\" AND severity>=ERROR"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "unrelated_alert_out_of_scope" {
  attrs = {
    display_name = "unrelated_alert_out_of_scope"
    combiner     = "OR"
    enabled      = true
    conditions = [{
      display_name = "c-unrelated_alert_out_of_scope"
      condition_threshold = [{
        filter          = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
      }]
    }]
  }
}
