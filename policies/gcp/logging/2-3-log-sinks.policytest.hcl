# Copyright IBM Corp. 2026

policytest {
  targets = ["2-3-log-sinks.policy.hcl"]
}

resource "google_logging_project_sink" "pass_project_filter_absent" {
  attrs = {
    name        = "sink-p1"
    destination = "storage.googleapis.com/log-bucket-p1"
  }
}

resource "google_logging_project_sink" "pass_project_filter_empty" {
  attrs = {
    name        = "sink-p2"
    destination = "storage.googleapis.com/log-bucket-p2"
    filter      = ""
  }
}

resource "google_logging_project_sink" "pass_project_filter_null" {
  attrs = {
    name        = "sink-p3"
    destination = "storage.googleapis.com/log-bucket-p3"
    filter      = null
  }
}

resource "google_logging_folder_sink" "pass_folder_filter_empty" {
  attrs = {
    name        = "sink-f1"
    folder      = "folders/123456789"
    destination = "bigquery.googleapis.com/projects/my-proj/datasets/logs_f1"
    filter      = ""
  }
}

resource "google_logging_organization_sink" "pass_org_filter_empty" {
  attrs = {
    name        = "sink-o1"
    org_id      = "123456789012"
    destination = "pubsub.googleapis.com/projects/my-proj/topics/logs-o1"
    filter      = ""
  }
}

resource "google_logging_billing_account_sink" "pass_billing_filter_absent" {
  attrs = {
    name            = "sink-b1"
    billing_account = "000000-AAAAAA-BBBBBB"
    destination     = "storage.googleapis.com/log-bucket-b1"
  }
}
