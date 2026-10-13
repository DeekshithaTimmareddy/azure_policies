# Copyright IBM Corp. 2026

policytest {
  targets = ["3-5-dnssec-no-rsasha1-zsk.policy.hcl"]
}

resource "google_dns_managed_zone" "fail_zsk_rsasha1" {
  expect_failure = true
  attrs = {
    name          = "zone-fail_zsk_rsasha1"
    dns_name      = "fail_zsk_rsasha1.example.com."
    dnssec_config = [{ kind = "dns#managedZoneDnsSecConfig", state = "on", non_existence = "nsec3", default_key_specs = [{ algorithm = "rsasha256", key_length = 2048, key_type = "keySigning", kind = "dns#dnsKeySpec" }, { algorithm = "rsasha1", key_length = 1024, key_type = "zoneSigning", kind = "dns#dnsKeySpec" }] }]
  }
}

resource "google_dns_managed_zone" "fail_zsk_rsasha1_upper" {
  expect_failure = true
  attrs = {
    name          = "zone-fail_zsk_rsasha1_upper"
    dns_name      = "fail_zsk_rsasha1_upper.example.com."
    dnssec_config = [{ kind = "dns#managedZoneDnsSecConfig", state = "on", non_existence = "nsec3", default_key_specs = [{ algorithm = "RSASHA256", key_length = 2048, key_type = "keySigning", kind = "dns#dnsKeySpec" }, { algorithm = "RSASHA1", key_length = 1024, key_type = "zoneSigning", kind = "dns#dnsKeySpec" }] }]
  }
}

resource "google_dns_managed_zone" "fail_zsk_case_insensitive_key_type" {
  expect_failure = true
  attrs = {
    name          = "zone-fail_zsk_case_insensitive_key_type"
    dns_name      = "fail_zsk_case_insensitive_key_type.example.com."
    dnssec_config = [{ kind = "dns#managedZoneDnsSecConfig", state = "on", non_existence = "nsec3", default_key_specs = [{ algorithm = "RSASHA1", key_length = 1024, key_type = "ZONESIGNING", kind = "dns#dnsKeySpec" }] }]
  }
}

resource "google_dns_managed_zone" "pass_zsk_rsasha256" {
  attrs = {
    name          = "zone-pass_zsk_rsasha256"
    dns_name      = "pass_zsk_rsasha256.example.com."
    dnssec_config = [{ kind = "dns#managedZoneDnsSecConfig", state = "on", non_existence = "nsec3", default_key_specs = [{ algorithm = "rsasha256", key_length = 2048, key_type = "keySigning", kind = "dns#dnsKeySpec" }, { algorithm = "rsasha256", key_length = 1024, key_type = "zoneSigning", kind = "dns#dnsKeySpec" }] }]
  }
}

resource "google_dns_managed_zone" "pass_zsk_ecdsa" {
  attrs = {
    name          = "zone-pass_zsk_ecdsa"
    dns_name      = "pass_zsk_ecdsa.example.com."
    dnssec_config = [{ kind = "dns#managedZoneDnsSecConfig", state = "on", non_existence = "nsec3", default_key_specs = [{ algorithm = "ecdsap256sha256", key_length = 256, key_type = "keySigning", kind = "dns#dnsKeySpec" }, { algorithm = "ecdsap256sha256", key_length = 256, key_type = "zoneSigning", kind = "dns#dnsKeySpec" }] }]
  }
}

resource "google_dns_managed_zone" "pass_ksk_rsasha1_only" {
  attrs = {
    name          = "zone-pass_ksk_rsasha1_only"
    dns_name      = "pass_ksk_rsasha1_only.example.com."
    dnssec_config = [{ kind = "dns#managedZoneDnsSecConfig", state = "on", non_existence = "nsec3", default_key_specs = [{ algorithm = "rsasha1", key_length = 2048, key_type = "keySigning", kind = "dns#dnsKeySpec" }, { algorithm = "rsasha256", key_length = 1024, key_type = "zoneSigning", kind = "dns#dnsKeySpec" }] }]
  }
}

resource "google_dns_managed_zone" "fail_mixed_zsk" {
  expect_failure = true
  attrs = {
    name          = "zone-fail_mixed_zsk"
    dns_name      = "fail_mixed_zsk.example.com."
    dnssec_config = [{ kind = "dns#managedZoneDnsSecConfig", state = "on", non_existence = "nsec3", default_key_specs = [{ algorithm = "rsasha256", key_length = 2048, key_type = "keySigning", kind = "dns#dnsKeySpec" }, { algorithm = "rsasha256", key_length = 1024, key_type = "zoneSigning", kind = "dns#dnsKeySpec" }, { algorithm = "rsasha1", key_length = 1024, key_type = "zoneSigning", kind = "dns#dnsKeySpec" }] }]
  }
}

resource "google_dns_managed_zone" "pass_no_dnssec" {
  attrs = {
    name     = "zone-pass_no_dnssec"
    dns_name = "pass_no_dnssec.example.com."
  }
}

resource "google_dns_managed_zone" "pass_dnssec_null" {
  attrs = {
    name          = "zone-pass_dnssec_null"
    dns_name      = "pass_dnssec_null.example.com."
    dnssec_config = null
  }
}

resource "google_dns_managed_zone" "pass_empty_specs" {
  attrs = {
    name          = "zone-pass_empty_specs"
    dns_name      = "pass_empty_specs.example.com."
    dnssec_config = [{ kind = "dns#managedZoneDnsSecConfig", state = "on", non_existence = "nsec3", default_key_specs = [] }]
  }
}

resource "google_dns_managed_zone" "pass_null_specs" {
  attrs = {
    name          = "zone-pass_null_specs"
    dns_name      = "pass_null_specs.example.com."
    dnssec_config = [{ kind = "dns#managedZoneDnsSecConfig", state = "on", non_existence = "nsec3", default_key_specs = null }]
  }
}
