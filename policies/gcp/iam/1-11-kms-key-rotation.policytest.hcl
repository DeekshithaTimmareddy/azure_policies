# Copyright IBM Corp. 2026

policytest {
  targets = ["1-11-kms-key-rotation.policy.hcl"]
}

resource "google_kms_crypto_key" "pass_90d" {
  attrs = {
    name     = "key-pass_90d"
    key_ring = "projects/p/locations/us/keyRings/kr-pass_90d"
    rotation_period = "7776000s"
  }
}

resource "google_kms_crypto_key" "pass_90d_minutes" {
  attrs = {
    name            = "key-pass_90d_minutes"
    key_ring        = "projects/p/locations/us/keyRings/kr-pass_90d_minutes"
    rotation_period = "129600m"
  }
}

resource "google_kms_crypto_key" "pass_90d_hours" {
  attrs = {
    name            = "key-pass_90d_hours"
    key_ring        = "projects/p/locations/us/keyRings/kr-pass_90d_hours"
    rotation_period = "2160h"
  }
}

resource "google_kms_crypto_key" "pass_90d_days" {
  attrs = {
    name            = "key-pass_90d_days"
    key_ring        = "projects/p/locations/us/keyRings/kr-pass_90d_days"
    rotation_period = "90d"
  }
}

resource "google_kms_crypto_key" "pass_30d" {
  attrs = {
    name     = "key-pass_30d"
    key_ring = "projects/p/locations/us/keyRings/kr-pass_30d"
    rotation_period = "2592000s"
  }
}

resource "google_kms_crypto_key" "pass_1d" {
  attrs = {
    name     = "key-pass_1d"
    key_ring = "projects/p/locations/us/keyRings/kr-pass_1d"
    rotation_period = "86400s"
  }
}

resource "google_kms_crypto_key" "fail_fractional_period" {
  expect_failure = true
  attrs = {
    name     = "key-fail_fractional_period"
    key_ring = "projects/p/locations/us/keyRings/kr-fail_fractional_period"
    rotation_period = "1.5d"
  }
}

resource "google_kms_crypto_key" "fail_90d_plus_1s" {
  expect_failure = true
  attrs = {
    name     = "key-fail_90d_plus_1s"
    key_ring = "projects/p/locations/us/keyRings/kr-fail_90d_plus_1s"
    rotation_period = "7776001s"
  }
}

resource "google_kms_crypto_key" "fail_100d" {
  expect_failure = true
  attrs = {
    name     = "key-fail_100d"
    key_ring = "projects/p/locations/us/keyRings/kr-fail_100d"
    rotation_period = "8640000s"
  }
}

resource "google_kms_crypto_key" "fail_365d" {
  expect_failure = true
  attrs = {
    name     = "key-fail_365d"
    key_ring = "projects/p/locations/us/keyRings/kr-fail_365d"
    rotation_period = "31536000s"
  }
}

resource "google_kms_crypto_key" "fail_absent" {
  expect_failure = true
  attrs = {
    name     = "key-fail_absent"
    key_ring = "projects/p/locations/us/keyRings/kr-fail_absent"
  }
}

resource "google_kms_crypto_key" "fail_null" {
  expect_failure = true
  attrs = {
    name     = "key-fail_null"
    key_ring = "projects/p/locations/us/keyRings/kr-fail_null"
    rotation_period = null
  }
}

resource "google_kms_crypto_key" "fail_empty" {
  expect_failure = true
  attrs = {
    name     = "key-fail_empty"
    key_ring = "projects/p/locations/us/keyRings/kr-fail_empty"
    rotation_period = ""
  }
}
