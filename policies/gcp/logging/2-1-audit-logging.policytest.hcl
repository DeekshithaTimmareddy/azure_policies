# Copyright IBM Corp. 2026

policytest {
  targets = ["2-1-audit-logging.policy.hcl"]
}

resource "google_project_iam_audit_config" "pass_all_types" {
  attrs = {
    project = "proj-a"
    service = "allServices"
    audit_log_config = [
      { log_type = "ADMIN_READ" },
      { log_type = "DATA_WRITE" },
      { log_type = "DATA_READ" },
    ]
  }
}

resource "google_project_iam_audit_config" "pass_read_write_only" {
  attrs = {
    project = "proj-b"
    service = "allServices"
    audit_log_config = [
      { log_type = "DATA_WRITE" },
      { log_type = "DATA_READ" },
    ]
  }
}

resource "google_project_iam_audit_config" "pass_exempted_null" {
  attrs = {
    project = "proj-c"
    service = "allServices"
    audit_log_config = [
      { log_type = "DATA_WRITE", exempted_members = null },
      { log_type = "DATA_READ", exempted_members = null },
    ]
  }
}

resource "google_project_iam_audit_config" "pass_exempted_empty" {
  attrs = {
    project = "proj-d"
    service = "allServices"
    audit_log_config = [
      { log_type = "DATA_WRITE", exempted_members = [] },
      { log_type = "DATA_READ", exempted_members = [] },
    ]
  }
}

resource "google_project_iam_audit_config" "fail_only_data_read" {
  expect_failure = true
  attrs = {
    project = "proj-e"
    service = "allServices"
    audit_log_config = [
      { log_type = "DATA_READ" },
    ]
  }
}

resource "google_project_iam_audit_config" "fail_missing_data_read" {
  expect_failure = true
  attrs = {
    project = "proj-f"
    service = "allServices"
    audit_log_config = [
      { log_type = "ADMIN_READ" },
      { log_type = "DATA_WRITE" },
    ]
  }
}

resource "google_project_iam_audit_config" "fail_partial_exemption" {
  expect_failure = true
  attrs = {
    project = "proj-g"
    service = "allServices"
    audit_log_config = [
      { log_type = "ADMIN_READ", exempted_members = [] },
      { log_type = "DATA_WRITE", exempted_members = ["user:alice@example.com"] },
      { log_type = "DATA_READ" },
    ]
  }
}

resource "google_project_iam_audit_config" "fail_service_specific_exemption" {
  expect_failure = true
  attrs = {
    project = "proj-h"
    service = "storage.googleapis.com"
    audit_log_config = [
      { log_type = "DATA_READ", exempted_members = ["serviceAccount:sa@proj-h.iam.gserviceaccount.com"] },
      { log_type = "DATA_WRITE" },
    ]
  }
}

resource "google_project_iam_policy" "fail_project_policy_audit_exemption" {
  expect_failure = true
  attrs = {
    project     = "proj-policy-audit"
    policy_data = "{\"auditConfigs\":[{\"service\":\"allServices\",\"auditLogConfigs\":[{\"logType\":\"DATA_READ\"},{\"logType\":\"DATA_WRITE\",\"exemptedMembers\":[\"user:alice@example.com\"]}]}]}"
  }
}

resource "google_project_iam_policy" "pass_project_policy_all_services" {
  attrs = {
    project     = "proj-policy-pass"
    policy_data = "{\"auditConfigs\":[{\"service\":\"allServices\",\"auditLogConfigs\":[{\"logType\":\"DATA_READ\"},{\"logType\":\"DATA_WRITE\"}]}]}"
  }
}

resource "google_project_iam_policy" "pass_project_policy_inherited_audit_config" {
  attrs = {
    project     = "proj-policy-missing-audit"
    policy_data = "{}"
  }
}

resource "google_folder_iam_audit_config" "pass_folder" {
  attrs = {
    folder  = "folders/123456789"
    service = "allServices"
    audit_log_config = [
      { log_type = "DATA_WRITE" },
      { log_type = "DATA_READ" },
    ]
  }
}

resource "google_folder_iam_audit_config" "fail_folder_admin_only" {
  expect_failure = true
  attrs = {
    folder  = "folders/987654321"
    service = "allServices"
    audit_log_config = [
      { log_type = "ADMIN_READ" },
    ]
  }
}

resource "google_organization_iam_audit_config" "pass_org" {
  attrs = {
    org_id  = "111111111111"
    service = "allServices"
    audit_log_config = [
      { log_type = "ADMIN_READ" },
      { log_type = "DATA_READ" },
      { log_type = "DATA_WRITE" },
    ]
  }
}

resource "google_organization_iam_audit_config" "fail_org_exemption" {
  expect_failure = true
  attrs = {
    org_id  = "222222222222"
    service = "allServices"
    audit_log_config = [
      { log_type = "DATA_READ" },
      { log_type = "DATA_WRITE", exempted_members = ["group:admins@example.com"] },
    ]
  }
}

resource "google_folder_iam_policy" "pass_folder_policy_all_services" {
  attrs = {
    folder      = "folders/123456789"
    policy_data = "{\"auditConfigs\":[{\"service\":\"allServices\",\"auditLogConfigs\":[{\"logType\":\"DATA_READ\"},{\"logType\":\"DATA_WRITE\"}]}]}"
  }
}

resource "google_folder_iam_policy" "fail_folder_policy_audit_exemption" {
  expect_failure = true
  attrs = {
    folder      = "folders/987654321"
    policy_data = "{\"auditConfigs\":[{\"service\":\"allServices\",\"auditLogConfigs\":[{\"logType\":\"DATA_READ\"},{\"logType\":\"DATA_WRITE\",\"exemptedMembers\":[\"group:admins@example.com\"]}]}]}"
  }
}

resource "google_organization_iam_policy" "fail_org_policy_audit_exemption" {
  expect_failure = true
  attrs = {
    org_id      = "333333333333"
    policy_data = "{\"auditConfigs\":[{\"service\":\"allServices\",\"auditLogConfigs\":[{\"logType\":\"DATA_READ\"},{\"logType\":\"DATA_WRITE\",\"exemptedMembers\":[\"user:bob@example.com\"]}]}]}"
  }
}

resource "google_organization_iam_policy" "fail_org_policy_missing_audit_config" {
  expect_failure = true
  attrs = {
    org_id      = "444444444444"
    policy_data = "{}"
  }
}
