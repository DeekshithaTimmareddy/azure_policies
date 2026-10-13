# Copyright IBM Corp. 2026

policytest {
  targets = ["1-15-api-key-restrictions.policy.hcl"]
}

resource "google_apikeys_key" "pass_single_target" {
  attrs = {
    name = "key-pass-1"
    restrictions = [{ api_targets = [{ service = "translate.googleapis.com", methods = [] }] }]
  }
}

resource "google_apikeys_key" "pass_multi_target" {
  attrs = {
    name = "key-pass-2"
    restrictions = [{ api_targets = [
      { service = "translate.googleapis.com", methods = ["GET*"] },
      { service = "maps-backend.googleapis.com", methods = [] }
    ] }]
  }
}

resource "google_apikeys_key" "fail_browser_only" {
  expect_failure = true
  attrs = {
    name = "key-fail-browser"
    restrictions = [{ browser_key_restrictions = [{ allowed_referrers = [".*\\.example\\.com"] }] }]
  }
}

resource "google_apikeys_key" "fail_restrictions_absent" {
  expect_failure = true
  attrs = {
    name = "key-fail-absent"
  }
}

resource "google_apikeys_key" "fail_restrictions_null" {
  expect_failure = true
  attrs = {
    name         = "key-fail-null"
    restrictions = null
  }
}

resource "google_apikeys_key" "fail_restrictions_empty" {
  expect_failure = true
  attrs = {
    name         = "key-fail-empty"
    restrictions = []
  }
}

resource "google_apikeys_key" "fail_api_targets_empty" {
  expect_failure = true
  attrs = {
    name         = "key-fail-targets-empty"
    restrictions = [{ api_targets = [] }]
  }
}

resource "google_apikeys_key" "fail_api_targets_null" {
  expect_failure = true
  attrs = {
    name         = "key-fail-targets-null"
    restrictions = [{ api_targets = null }]
  }
}

resource "google_apikeys_key" "fail_cloudapis_only" {
  expect_failure = true
  attrs = {
    name         = "key-fail-cloudapis"
    restrictions = [{ api_targets = [{ service = "cloudapis.googleapis.com", methods = [] }] }]
  }
}

resource "google_apikeys_key" "fail_whitespace_service" {
  expect_failure = true
  attrs = {
    name         = "key-fail-whitespace-service"
    restrictions = [{ api_targets = [{ service = "   ", methods = [] }] }]
  }
}

resource "google_apikeys_key" "fail_mixed_cloudapis" {
  expect_failure = true
  attrs = {
    name = "key-fail-mixed"
    restrictions = [{ api_targets = [
      { service = "translate.googleapis.com", methods = [] },
      { service = "cloudapis.googleapis.com", methods = [] }
    ] }]
  }
}
