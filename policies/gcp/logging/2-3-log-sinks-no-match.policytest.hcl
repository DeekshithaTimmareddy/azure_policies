# Copyright IBM Corp. 2026

policytest {
  targets = ["2-3-log-sinks.policy.hcl"]
}

resource "google_logging_project_sink" "fail_disabled_all_logs_sink" {
  expect_failure = true
  attrs = {
    name        = "disabled-all-logs"
    destination = "pubsub.googleapis.com/projects/my-project/topics/logs"
    filter      = ""
    disabled    = true
  }
}

resource "google_logging_project_sink" "fail_enabled_exclusion" {
  expect_failure = true
  attrs = {
    name        = "excluding-all-logs"
    destination = "pubsub.googleapis.com/projects/my-project/topics/logs"
    filter      = ""
    disabled    = false
    exclusions  = [{ name = "exclude-all", filter = "logName:*", disabled = false }]
  }
}

resource "google_logging_project_sink" "fail_project_filter_set" {
  expect_failure = true
  attrs = {
    name        = "sink-p4"
    destination = "storage.googleapis.com/log-bucket-p4"
    filter      = "severity >= ERROR"
  }
}

resource "google_logging_folder_sink" "fail_folder_filter_set" {
  expect_failure = true
  attrs = {
    name        = "sink-f2"
    folder      = "folders/123456789"
    destination = "bigquery.googleapis.com/projects/my-proj/datasets/logs_f2"
    filter      = "resource.type = \"gce_instance\""
  }
}

resource "google_logging_organization_sink" "fail_org_filter_set" {
  expect_failure = true
  attrs = {
    name        = "sink-o2"
    org_id      = "123456789012"
    destination = "pubsub.googleapis.com/projects/my-proj/topics/logs-o2"
    filter      = "logName:\"cloudaudit.googleapis.com\""
  }
}

resource "google_logging_billing_account_sink" "fail_billing_filter_set" {
  expect_failure = true
  attrs = {
    name            = "sink-b2"
    billing_account = "000000-AAAAAA-BBBBBB"
    destination     = "storage.googleapis.com/log-bucket-b2"
    filter          = "severity >= WARNING"
  }
}

resource "google_logging_project_sink" "fail_destination_empty" {
  expect_failure = true
  attrs = {
    name        = "sink-p5"
    destination = "   "
    filter      = ""
  }
}

resource "google_logging_project_sink" "fail_destination_null" {
  expect_failure = true
  attrs = {
    name        = "sink-p6"
    destination = null
    filter      = ""
  }
}
