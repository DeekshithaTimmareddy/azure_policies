# Copyright IBM Corp. 2026

policytest {
  targets = ["1-5-service-account-keys.policy.hcl"]
}

resource "google_service_account" "pass_sa_without_keys" {
  attrs = {
    account_id   = "app-sa"
    display_name = "App SA"
  }
}

resource "google_service_account_key" "fail_user_managed_key" {
  expect_failure = true
  attrs = {
    service_account_id = "projects/p/serviceAccounts/app@p.iam.gserviceaccount.com"
  }
}

resource "google_service_account_key" "fail_key_with_algorithm" {
  expect_failure = true
  attrs = {
    service_account_id = "projects/p/serviceAccounts/app2@p.iam.gserviceaccount.com"
    key_algorithm      = "KEY_ALG_RSA_2048"
    private_key_type   = "TYPE_GOOGLE_CREDENTIALS_FILE"
  }
}

resource "google_service_account_key" "fail_uploaded_public_key" {
  expect_failure = true
  attrs = {
    service_account_id = "projects/p/serviceAccounts/app3@p.iam.gserviceaccount.com"
    public_key_data    = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0t"
  }
}

resource "google_service_account_key" "fail_bare_email" {
  expect_failure = true
  attrs = {
    service_account_id = "app4@p.iam.gserviceaccount.com"
  }
}
