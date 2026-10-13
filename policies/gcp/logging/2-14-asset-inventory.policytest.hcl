# Copyright IBM Corp. 2026

policytest {
  targets = ["2-14-asset-inventory.policy.hcl"]
}

resource "google_project" "pass_project_with_cloudasset" {
  attrs = {
    name       = "proj-2-14-a"
    project_id = "proj-2-14-a"
  }
}

resource "google_project_service" "pass_cloudasset_enabled" {
  attrs = {
    service = "cloudasset.googleapis.com"
    project = "proj-2-14-a"
  }
}

resource "google_project" "fail_project_only_other_service" {
  expect_failure = true
  attrs = {
    name       = "proj-2-14-b"
    project_id = "proj-2-14-b"
  }
}

resource "google_project_service" "pass_other_service_on_project_b" {
  attrs = {
    service = "compute.googleapis.com"
    project = "proj-2-14-b"
  }
}

resource "google_project" "fail_project_no_services" {
  expect_failure = true
  attrs = {
    name       = "proj-2-14-c"
    project_id = "proj-2-14-c"
  }
}

resource "google_project" "fail_project_cloudasset_on_other_project" {
  expect_failure = true
  attrs = {
    name       = "proj-2-14-d"
    project_id = "proj-2-14-d"
  }
}
