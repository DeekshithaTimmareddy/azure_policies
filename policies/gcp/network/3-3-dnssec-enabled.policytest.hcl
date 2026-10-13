# Copyright IBM Corp. 2026

policytest {
  targets = ["3-3-dnssec-enabled.policy.hcl"]
}

resource "google_dns_managed_zone" "pass_public_on" {
  attrs = {
    name          = "zone-pass_public_on"
    dns_name      = "pass_public_on.example.com."
    visibility    = "public"
    dnssec_config = [{ state = "on" }]
  }
}

resource "google_dns_managed_zone" "fail_public_off" {
  expect_failure = true
  attrs = {
    name          = "zone-fail_public_off"
    dns_name      = "fail_public_off.example.com."
    visibility    = "public"
    dnssec_config = [{ state = "off" }]
  }
}

resource "google_dns_managed_zone" "fail_public_transfer" {
  expect_failure = true
  attrs = {
    name          = "zone-fail_public_transfer"
    dns_name      = "fail_public_transfer.example.com."
    visibility    = "public"
    dnssec_config = [{ state = "transfer" }]
  }
}

resource "google_dns_managed_zone" "fail_public_dnssec_absent" {
  expect_failure = true
  attrs = {
    name       = "zone-fail_public_dnssec_absent"
    dns_name   = "fail_public_dnssec_absent.example.com."
    visibility = "public"
  }
}

resource "google_dns_managed_zone" "fail_public_dnssec_null" {
  expect_failure = true
  attrs = {
    name          = "zone-fail_public_dnssec_null"
    dns_name      = "fail_public_dnssec_null.example.com."
    visibility    = "public"
    dnssec_config = null
  }
}

resource "google_dns_managed_zone" "fail_public_dnssec_empty" {
  expect_failure = true
  attrs = {
    name          = "zone-fail_public_dnssec_empty"
    dns_name      = "fail_public_dnssec_empty.example.com."
    visibility    = "public"
    dnssec_config = []
  }
}

resource "google_dns_managed_zone" "fail_public_state_absent" {
  expect_failure = true
  attrs = {
    name          = "zone-fail_public_state_absent"
    dns_name      = "fail_public_state_absent.example.com."
    visibility    = "public"
    dnssec_config = [{ kind = "dns#managedZoneDnsSecConfig" }]
  }
}

resource "google_dns_managed_zone" "fail_public_state_null" {
  expect_failure = true
  attrs = {
    name          = "zone-fail_public_state_null"
    dns_name      = "fail_public_state_null.example.com."
    visibility    = "public"
    dnssec_config = [{ state = null }]
  }
}

resource "google_dns_managed_zone" "fail_public_state_blank" {
  expect_failure = true
  attrs = {
    name          = "zone-fail_public_state_blank"
    dns_name      = "fail_public_state_blank.example.com."
    visibility    = "public"
    dnssec_config = [{ state = "" }]
  }
}

resource "google_dns_managed_zone" "pass_private_dnssec_absent" {
  attrs = {
    name       = "zone-pass_private_dnssec_absent"
    dns_name   = "pass_private_dnssec_absent.example.com."
    visibility = "private"
  }
}

resource "google_dns_managed_zone" "pass_private_off" {
  attrs = {
    name          = "zone-pass_private_off"
    dns_name      = "pass_private_off.example.com."
    visibility    = "private"
    dnssec_config = [{ state = "off" }]
  }
}

resource "google_dns_managed_zone" "fail_default_visibility_off" {
  expect_failure = true
  attrs = {
    name          = "zone-fail_default_visibility_off"
    dns_name      = "fail_default_visibility_off.example.com."
    dnssec_config = [{ state = "off" }]
  }
}

resource "google_dns_managed_zone" "pass_default_visibility_on" {
  attrs = {
    name          = "zone-pass_default_visibility_on"
    dns_name      = "pass_default_visibility_on.example.com."
    dnssec_config = [{ state = "on" }]
  }
}

resource "google_dns_managed_zone" "fail_null_visibility_off" {
  expect_failure = true
  attrs = {
    name          = "zone-fail-null-visibility-off"
    dns_name      = "fail-null-visibility-off.example.com."
    visibility    = null
    dnssec_config = [{ state = "off" }]
  }
}

resource "google_dns_managed_zone" "fail_empty_visibility_off" {
  expect_failure = true
  attrs = {
    name          = "zone-fail-empty-visibility-off"
    dns_name      = "fail-empty-visibility-off.example.com."
    visibility    = ""
    dnssec_config = [{ state = "off" }]
  }
}
