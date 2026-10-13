# Copyright IBM Corp. 2026

policytest {
  targets = ["2-7-custom-role-change-alert.policy.hcl"]
}

resource "google_logging_metric" "fail_missing_undelete" {
  expect_failure = true
  attrs = {
    name   = "fail-missing-undelete"
    filter = "resource.type=\"iam_role\" AND (protoPayload.methodName=\"google.iam.admin.v1.CreateRole\" OR protoPayload.methodName=\"google.iam.admin.v1.DeleteRole\" OR protoPayload.methodName=\"google.iam.admin.v1.UpdateRole\")"
  }
}

resource "google_logging_metric" "fail_wrong_resource_type" {
  expect_failure = true
  attrs = {
    name   = "fail-wrong-resource-type"
    filter = "resource.type=\"gce_instance\" AND (protoPayload.methodName=\"google.iam.admin.v1.CreateRole\" OR protoPayload.methodName=\"google.iam.admin.v1.DeleteRole\" OR protoPayload.methodName=\"google.iam.admin.v1.UpdateRole\" OR protoPayload.methodName=\"google.iam.admin.v1.UndeleteRole\")"
  }
}

resource "google_logging_metric" "fail_empty_filter" {
  expect_failure = true
  attrs = {
    name   = "fail-empty-filter"
    filter = ""
  }
}

resource "google_logging_metric" "fail_no_alert" {
  expect_failure = true
  attrs = {
    name   = "fail-no-alert"
    filter = "resource.type=\"iam_role\" AND (protoPayload.methodName=\"google.iam.admin.v1.CreateRole\" OR protoPayload.methodName=\"google.iam.admin.v1.DeleteRole\" OR protoPayload.methodName=\"google.iam.admin.v1.UpdateRole\" OR protoPayload.methodName=\"google.iam.admin.v1.UndeleteRole\")"
  }
}

resource "google_logging_metric" "fail_disabled_alert" {
  expect_failure = true
  attrs = {
    name   = "fail-disabled-alert"
    filter = "resource.type=\"iam_role\" AND (protoPayload.methodName=\"google.iam.admin.v1.CreateRole\" OR protoPayload.methodName=\"google.iam.admin.v1.DeleteRole\" OR protoPayload.methodName=\"google.iam.admin.v1.UpdateRole\" OR protoPayload.methodName=\"google.iam.admin.v1.UndeleteRole\")"
  }
}

resource "google_monitoring_alert_policy" "alert_disabled" {
  skip = true
  attrs = {
    display_name = "alert-disabled"
    combiner     = "OR"
    enabled      = false
    conditions = [{
      display_name = "custom-role-changes"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/fail-disabled-alert\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        duration        = "0s"
        threshold_value = 0
      }]
    }]
  }
}

resource "google_logging_metric" "fail_wrong_alert_reference" {
  expect_failure = true
  attrs = {
    name   = "fail-wrong-alert-reference"
    filter = "resource.type=\"iam_role\" AND (protoPayload.methodName=\"google.iam.admin.v1.CreateRole\" OR protoPayload.methodName=\"google.iam.admin.v1.DeleteRole\" OR protoPayload.methodName=\"google.iam.admin.v1.UpdateRole\" OR protoPayload.methodName=\"google.iam.admin.v1.UndeleteRole\")"
  }
}

resource "google_monitoring_alert_policy" "alert_wrong_reference" {
  skip = true
  attrs = {
    display_name = "alert-wrong-reference"
    combiner     = "OR"
    enabled      = true
    conditions = [{
      display_name = "custom-role-changes"
      condition_threshold = [{
        filter          = "metric.type=\"logging.googleapis.com/user/some-other-metric\" AND resource.type=\"global\""
        comparison      = "COMPARISON_GT"
        duration        = "0s"
        threshold_value = 0
      }]
    }]
  }
}
