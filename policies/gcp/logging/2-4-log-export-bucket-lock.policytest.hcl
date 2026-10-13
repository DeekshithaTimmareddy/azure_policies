# Copyright IBM Corp. 2026

policytest {
  targets = ["2-4-log-export-bucket-lock.policy.hcl"]
}

resource "google_storage_bucket" "logs_b01" {
  attrs = {
    name     = "logs-b01"
    location = "US"
    retention_policy = [{
      retention_period = "2592000"
      is_locked        = true
    }]
  }
}

resource "google_logging_project_sink" "sink_b01" {
  attrs = {
    name        = "sink_b01"
    destination = "storage.googleapis.com/logs-b01"
  }
}

resource "google_storage_bucket" "logs_b02" {
  expect_failure = true
  attrs = {
    name     = "logs-b02"
    location = "US"
    retention_policy = [{
      retention_period = "2592000"
      is_locked        = false
    }]
  }
}

resource "google_logging_project_sink" "sink_b02" {
  attrs = {
    name        = "sink_b02"
    destination = "storage.googleapis.com/logs-b02"
  }
}

resource "google_storage_bucket" "logs_b03" {
  expect_failure = true
  attrs = {
    name     = "logs-b03"
    location = "US"
    retention_policy = [{
      retention_period = "2592000"
    }]
  }
}

resource "google_logging_project_sink" "sink_b03" {
  attrs = {
    name        = "sink_b03"
    destination = "storage.googleapis.com/logs-b03"
  }
}

resource "google_storage_bucket" "logs_b04" {
  expect_failure = true
  attrs = {
    name     = "logs-b04"
    location = "US"
    retention_policy = [{
      retention_period = "2592000"
      is_locked        = null
    }]
  }
}

resource "google_logging_project_sink" "sink_b04" {
  attrs = {
    name        = "sink_b04"
    destination = "storage.googleapis.com/logs-b04"
  }
}

resource "google_storage_bucket" "logs_b05" {
  expect_failure = true
  attrs = {
    name     = "logs-b05"
    location = "US"
  }
}

resource "google_logging_project_sink" "sink_b05" {
  attrs = {
    name        = "sink_b05"
    destination = "storage.googleapis.com/logs-b05"
  }
}

resource "google_storage_bucket" "logs_b06" {
  expect_failure = true
  attrs = {
    name     = "logs-b06"
    location = "US"
    retention_policy = []
  }
}

resource "google_logging_project_sink" "sink_b06" {
  attrs = {
    name        = "sink_b06"
    destination = "storage.googleapis.com/logs-b06"
  }
}

resource "google_storage_bucket" "logs_b07" {
  expect_failure = true
  attrs = {
    name     = "logs-b07"
    location = "US"
    retention_policy = null
  }
}

resource "google_logging_project_sink" "sink_b07" {
  attrs = {
    name        = "sink_b07"
    destination = "storage.googleapis.com/logs-b07"
  }
}

resource "google_storage_bucket" "app_b08" {
  attrs = {
    name     = "app-b08"
    location = "US"
  }
}

resource "google_logging_project_sink" "sink_bq" {
  attrs = {
    name        = "sink_bq"
    destination = "bigquery.googleapis.com/projects/my-proj/datasets/logs_ds"
  }
}

resource "google_storage_bucket" "logs_folder_sink" {
  expect_failure = true
  attrs = {
    name     = "logs-folder-sink"
    location = "US"
    retention_policy = [{ retention_period = "2592000", is_locked = false }]
  }
}

resource "google_logging_folder_sink" "sink_folder_bucket" {
  attrs = {
    name        = "sink-folder-bucket"
    folder      = "folders/123456789"
    destination = "storage.googleapis.com/logs-folder-sink"
  }
}

resource "google_storage_bucket" "logs_org_sink" {
  expect_failure = true
  attrs = {
    name     = "logs-org-sink"
    location = "US"
    retention_policy = [{
      retention_period = "2592000"
      is_locked        = false
    }]
  }
}

resource "google_logging_organization_sink" "sink_org_bucket" {
  attrs = {
    name        = "sink-org-bucket"
    org_id      = "123456789012"
    destination = "storage.googleapis.com/logs-org-sink"
  }
}

resource "google_storage_bucket" "logs_billing_sink" {
  expect_failure = true
  attrs = {
    name     = "logs-billing-sink"
    location = "US"
    retention_policy = [{
      retention_period = "2592000"
      is_locked        = false
    }]
  }
}

resource "google_logging_billing_account_sink" "sink_billing_bucket" {
  attrs = {
    name            = "sink-billing-bucket"
    billing_account = "000000-AAAAAA-BBBBBB"
    destination     = "storage.googleapis.com/logs-billing-sink"
  }
}
