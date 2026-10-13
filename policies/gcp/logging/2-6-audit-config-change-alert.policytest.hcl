# Copyright IBM Corp. 2026

policytest {
  targets = ["2-6-audit-config-change-alert.policy.hcl"]
}

resource "google_logging_metric" "audit_cfg_ok" {
  attrs = {
    name              = "audit-cfg-ok"
    filter            = "protoPayload.methodName=\"SetIamPolicy\" AND protoPayload.serviceData.policyDelta.auditConfigDeltas:*"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_ok" {
  skip = true
  attrs = {
    display_name = "alert_ok"
    combiner     = "OR"
    enabled      = true
    conditions   = [{ display_name = "c", condition_threshold = [{ comparison = "COMPARISON_GT", duration = "0s", threshold_value = 0, filter = "metric.type=\"logging.googleapis.com/user/audit-cfg-ok\" AND resource.type=\"global\"" }] }]
  }
}

resource "google_logging_metric" "audit_cfg_default_enabled" {
  attrs = {
    name              = "audit-cfg-default"
    filter            = "protoPayload.methodName=\"SetIamPolicy\" AND protoPayload.serviceData.policyDelta.auditConfigDeltas:*"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_default_enabled" {
  skip = true
  attrs = {
    display_name = "alert_default_enabled"
    combiner     = "OR"
    conditions   = [{ display_name = "c", condition_threshold = [{ comparison = "COMPARISON_GT", duration = "0s", threshold_value = 0, filter = "metric.type=\"logging.googleapis.com/user/audit-cfg-default\" AND resource.type=\"global\"" }] }]
  }
}

resource "google_logging_metric" "audit_cfg_no_alert" {
  expect_failure = true
  attrs = {
    name              = "audit-cfg-noalert"
    filter            = "protoPayload.methodName=\"SetIamPolicy\" AND protoPayload.serviceData.policyDelta.auditConfigDeltas:*"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_logging_metric" "audit_cfg_disabled" {
  expect_failure = true
  attrs = {
    name              = "audit-cfg-disabled"
    filter            = "protoPayload.methodName=\"SetIamPolicy\" AND protoPayload.serviceData.policyDelta.auditConfigDeltas:*"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_disabled" {
  skip = true
  attrs = {
    display_name = "alert_disabled"
    combiner     = "OR"
    enabled      = false
    conditions   = [{ display_name = "c", condition_threshold = [{ comparison = "COMPARISON_GT", duration = "0s", threshold_value = 0, filter = "metric.type=\"logging.googleapis.com/user/audit-cfg-disabled\" AND resource.type=\"global\"" }] }]
  }
}

resource "google_logging_metric" "audit_cfg_wrongref" {
  expect_failure = true
  attrs = {
    name              = "audit-cfg-wrongref"
    filter            = "protoPayload.methodName=\"SetIamPolicy\" AND protoPayload.serviceData.policyDelta.auditConfigDeltas:*"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_wrongref" {
  skip = true
  attrs = {
    display_name = "alert_wrongref"
    combiner     = "OR"
    enabled      = true
    conditions   = [{ display_name = "c", condition_threshold = [{ comparison = "COMPARISON_GT", duration = "0s", threshold_value = 0, filter = "metric.type=\"logging.googleapis.com/user/some-other-metric\" AND resource.type=\"global\"" }] }]
  }
}

resource "google_logging_metric" "ch_prefix_collision" {
  expect_failure = true
  attrs = {
    name              = "audit-pfx"
    filter            = "protoPayload.methodName=\"SetIamPolicy\" AND protoPayload.serviceData.policyDelta.auditConfigDeltas:*"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_prefix_collision" {
  skip = true
  attrs = {
    display_name = "alert_prefix_collision"
    combiner     = "OR"
    enabled      = true
    conditions   = [{ display_name = "c", condition_threshold = [{ comparison = "COMPARISON_GT", duration = "0s", threshold_value = 0, filter = "metric.type=\"logging.googleapis.com/user/audit-pfx-other\" AND resource.type=\"global\"" }] }]
  }
}

resource "google_logging_metric" "ch_substring_name" {
  expect_failure = true
  attrs = {
    name              = "audit-sfx-long"
    filter            = "protoPayload.methodName=\"SetIamPolicy\" AND protoPayload.serviceData.policyDelta.auditConfigDeltas:*"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_substring_name" {
  skip = true
  attrs = {
    display_name = "alert_substring_name"
    combiner     = "OR"
    enabled      = true
    conditions   = [{ display_name = "c", condition_threshold = [{ comparison = "COMPARISON_GT", duration = "0s", threshold_value = 0, filter = "metric.type=\"logging.googleapis.com/user/audit-sfx\" AND resource.type=\"global\"" }] }]
  }
}

resource "google_logging_metric" "audit_cfg_emptycond" {
  expect_failure = true
  attrs = {
    name              = "audit-cfg-emptycond"
    filter            = "protoPayload.methodName=\"SetIamPolicy\" AND protoPayload.serviceData.policyDelta.auditConfigDeltas:*"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_monitoring_alert_policy" "alert_emptycond" {
  skip = true
  attrs = {
    display_name = "alert_emptycond"
    combiner     = "OR"
    enabled      = true
    conditions   = []
  }
}

resource "google_logging_metric" "unrelated_metric" {
  attrs = {
    name              = "unrelated-metric"
    filter            = "resource.type=\"gce_instance\" AND severity>=ERROR"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_logging_metric" "fail_or_filter" {
  expect_failure = true
  attrs = {
    name              = "audit-or"
    filter            = "protoPayload.methodName=\"SetIamPolicy\" OR protoPayload.serviceData.policyDelta.auditConfigDeltas:*"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_logging_metric" "fail_negated_filter" {
  expect_failure = true
  attrs = {
    name              = "audit-neg"
    filter            = "NOT (protoPayload.methodName=\"SetIamPolicy\" AND protoPayload.serviceData.policyDelta.auditConfigDeltas:*)"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_logging_metric" "fail_missing_audit_config_clause" {
  expect_failure = true
  attrs = {
    name              = "audit-missing-delta"
    filter            = "protoPayload.methodName=\"SetIamPolicy\""
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_logging_metric" "fail_missing_method_clause" {
  expect_failure = true
  attrs = {
    name              = "audit-missing-method"
    filter            = "protoPayload.serviceData.policyDelta.auditConfigDeltas:*"
    metric_descriptor = [{ metric_kind = "DELTA", value_type = "INT64", unit = "1" }]
  }
}

resource "google_logging_metric" "fail_or_filter_with_alert" {
  expect_failure = true
  attrs = {
    name   = "audit-invalid-linked"
    filter = "protoPayload.methodName=\"SetIamPolicy\" OR protoPayload.serviceData.policyDelta.auditConfigDeltas:*"
  }
}

resource "google_monitoring_alert_policy" "alert_for_invalid_filter" {
  skip = true
  attrs = {
    enabled = true
    conditions = [{ condition_threshold = [{
      filter = "metric.type=\"logging.googleapis.com/user/audit-invalid-linked\" AND resource.type=\"global\""
    }] }]
  }
}
