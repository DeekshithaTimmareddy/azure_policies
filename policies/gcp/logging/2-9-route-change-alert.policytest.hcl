# Copyright IBM Corp. 2026

policytest {
  targets = ["2-9-route-change-alert.policy.hcl"]
}

resource "google_logging_metric" "pass_route_m1" {

  attrs = {
    name              = "route-m1"
    filter            = "resource.type=\"gce_route\" AND (protoPayload.methodName:\"compute.routes.delete\" OR protoPayload.methodName:\"compute.routes.insert\")"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_route_m1" {
  skip = true
  attrs = {
    display_name = "alert_route_m1"
    combiner     = "OR"
    enabled      = true
    conditions = [{
      display_name = "route change"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/route-m1\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
      }]
    }]
  }
}

resource "google_logging_metric" "fail_route_m2_no_alert" {
  expect_failure = true
  attrs = {
    name              = "route-m2"
    filter            = "resource.type=\"gce_route\" AND (protoPayload.methodName:\"compute.routes.delete\" OR protoPayload.methodName:\"compute.routes.insert\")"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_logging_metric" "fail_route_m3_alert_disabled" {
  expect_failure = true
  attrs = {
    name              = "route-m3"
    filter            = "resource.type=\"gce_route\" AND (protoPayload.methodName:\"compute.routes.delete\" OR protoPayload.methodName:\"compute.routes.insert\")"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_route_m3" {
  skip = true
  attrs = {
    display_name = "alert_route_m3"
    combiner     = "OR"
    enabled      = false
    conditions = [{
      display_name = "route change"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/route-m3\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
      }]
    }]
  }
}

resource "google_logging_metric" "pass_route_m4_enabled_default" {

  attrs = {
    name              = "route-m4"
    filter            = "resource.type=\"gce_route\" AND (protoPayload.methodName:\"compute.routes.delete\" OR protoPayload.methodName:\"compute.routes.insert\")"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_route_m4" {
  skip = true
  attrs = {
    display_name = "alert_route_m4"
    combiner     = "OR"
    enabled      = null
    conditions = [{
      display_name = "route change"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/route-m4\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
      }]
    }]
  }
}

resource "google_logging_metric" "fail_route_m5_alert_other_metric" {
  expect_failure = true
  attrs = {
    name              = "route-m5"
    filter            = "resource.type=\"gce_route\" AND (protoPayload.methodName:\"compute.routes.delete\" OR protoPayload.methodName:\"compute.routes.insert\")"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_route_m5" {
  skip = true
  attrs = {
    display_name = "alert_route_m5"
    combiner     = "OR"
    enabled      = true
    conditions = [{
      display_name = "route change"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/unrelated-m5\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
      }]
    }]
  }
}

resource "google_logging_metric" "pass_route_m7_second_condition" {

  attrs = {
    name              = "route-m7"
    filter            = "resource.type=\"gce_route\" AND (protoPayload.methodName:\"compute.routes.delete\" OR protoPayload.methodName:\"compute.routes.insert\")"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_route_m7" {
  skip = true
  attrs = {
    display_name = "alert_route_m7"
    combiner     = "OR"
    enabled      = true
    conditions = [{
      display_name = "route change"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/unrelated-m7\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
      }]
      }, {
      display_name = "route change"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/route-m7\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
      }]
    }]
  }
}

resource "google_logging_metric" "fail_route_m8_insert_only" {
  expect_failure = true
  attrs = {
    name              = "route-m8"
    filter            = "resource.type=\"gce_route\" AND protoPayload.methodName:\"compute.routes.insert\""
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_route_m8" {
  skip = true
  attrs = {
    display_name = "alert_route_m8"
    combiner     = "OR"
    enabled      = true
    conditions = [{
      display_name = "route change"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/route-m8\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
      }]
    }]
  }
}

resource "google_logging_metric" "fail_route_m9_delete_only" {
  expect_failure = true
  attrs = {
    name              = "route-m9"
    filter            = "resource.type=\"gce_route\" AND protoPayload.methodName:\"compute.routes.delete\""
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_route_m9" {
  skip = true
  attrs = {
    display_name = "alert_route_m9"
    combiner     = "OR"
    enabled      = true
    conditions = [{
      display_name = "route change"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/route-m9\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
      }]
    }]
  }
}

resource "google_logging_metric" "fail_route_m10_and_instead_of_or" {
  expect_failure = true
  attrs = {
    name              = "route-m10"
    filter            = "resource.type=\"gce_route\" AND (protoPayload.methodName:\"compute.routes.delete\" AND protoPayload.methodName:\"compute.routes.insert\")"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_route_m10" {
  skip = true
  attrs = {
    display_name = "alert_route_m10"
    combiner     = "OR"
    enabled      = true
    conditions = [{
      display_name = "route change"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/route-m10\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
      }]
    }]
  }
}

resource "google_logging_metric" "fail_route_m11_negated_methods" {
  expect_failure = true
  attrs = {
    name              = "route-m11"
    filter            = "resource.type=\"gce_route\" AND NOT (protoPayload.methodName:\"compute.routes.delete\" OR protoPayload.methodName:\"compute.routes.insert\")"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_route_m11" {
  skip = true
  attrs = {
    display_name = "alert_route_m11"
    combiner     = "OR"
    enabled      = true
    conditions = [{
      display_name = "route change"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/route-m11\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
      }]
    }]
  }
}

resource "google_logging_metric" "fail_route_m12_negated_dash" {
  expect_failure = true
  attrs = {
    name              = "route-m12"
    filter            = "resource.type=\"gce_route\" AND (-protoPayload.methodName:\"compute.routes.delete\" OR -protoPayload.methodName:\"compute.routes.insert\")"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_route_m12" {
  skip = true
  attrs = {
    display_name = "alert_route_m12"
    combiner     = "OR"
    enabled      = true
    conditions = [{
      display_name = "route change"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/route-m12\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
      }]
    }]
  }
}

resource "google_logging_metric" "fail_route_c1_prefix_collision" {
  expect_failure = true
  attrs = {
    name              = "route-c1"
    filter            = "resource.type=\"gce_route\" AND (protoPayload.methodName:\"compute.routes.delete\" OR protoPayload.methodName:\"compute.routes.insert\")"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_route_c1" {
  skip = true
  attrs = {
    display_name = "alert_route_c1"
    combiner     = "OR"
    enabled      = true
    conditions = [{
      display_name = "route change"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/route-c1-extra\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
      }]
    }]
  }
}

resource "google_logging_metric" "fail_route_c2_reverse_prefix" {
  expect_failure = true
  attrs = {
    name              = "route-c2-long"
    filter            = "resource.type=\"gce_route\" AND (protoPayload.methodName:\"compute.routes.delete\" OR protoPayload.methodName:\"compute.routes.insert\")"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_route_c2_long" {
  skip = true
  attrs = {
    display_name = "alert_route_c2_long"
    combiner     = "OR"
    enabled      = true
    conditions = [{
      display_name = "route change"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/route-c2\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        threshold_value = 0
        duration        = "0s"
      }]
    }]
  }
}

resource "google_logging_metric" "pass_firewall_m13_out_of_scope" {

  attrs = {
    name              = "fw-m13"
    filter            = "resource.type=\"gce_firewall_rule\" AND protoPayload.methodName:\"compute.firewalls.insert\""
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}
