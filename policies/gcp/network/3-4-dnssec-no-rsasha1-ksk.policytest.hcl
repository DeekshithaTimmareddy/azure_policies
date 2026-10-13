# Copyright IBM Corp. 2026

policytest {
  targets = ["3-4-dnssec-no-rsasha1-ksk.policy.hcl"]
}

resource "google_dns_managed_zone" "fail_ksk_rsasha1" {
  expect_failure = true
  attrs = {
    name     = "zone-f1"
    dns_name = "f1.example.com."
    dnssec_config = [{
      state = "on"
      default_key_specs = [
        { key_type = "keySigning", algorithm = "rsasha1", key_length = 2048 },
        { key_type = "zoneSigning", algorithm = "rsasha256", key_length = 1024 }
      ]
    }]
  }
}

resource "google_dns_managed_zone" "pass_ksk_rsasha256" {
  attrs = {
    name     = "zone-p1"
    dns_name = "p1.example.com."
    dnssec_config = [{
      state = "on"
      default_key_specs = [
        { key_type = "keySigning", algorithm = "rsasha256", key_length = 2048 },
        { key_type = "zoneSigning", algorithm = "rsasha256", key_length = 1024 }
      ]
    }]
  }
}

resource "google_dns_managed_zone" "pass_ksk_ecdsa" {
  attrs = {
    name     = "zone-p2"
    dns_name = "p2.example.com."
    dnssec_config = [{
      state = "on"
      default_key_specs = [
        { key_type = "keySigning", algorithm = "ecdsap256sha256", key_length = 256 }
      ]
    }]
  }
}

resource "google_dns_managed_zone" "pass_only_zsk_rsasha1" {
  attrs = {
    name     = "zone-p3"
    dns_name = "p3.example.com."
    dnssec_config = [{
      state = "on"
      default_key_specs = [
        { key_type = "keySigning", algorithm = "rsasha256", key_length = 2048 },
        { key_type = "zoneSigning", algorithm = "rsasha1", key_length = 1024 }
      ]
    }]
  }
}

resource "google_dns_managed_zone" "fail_some_ksk_rsasha1" {
  expect_failure = true
  attrs = {
    name     = "zone-f2"
    dns_name = "f2.example.com."
    dnssec_config = [{
      state = "on"
      default_key_specs = [
        { key_type = "keySigning", algorithm = "rsasha256", key_length = 2048 },
        { key_type = "keySigning", algorithm = "rsasha1", key_length = 2048 }
      ]
    }]
  }
}

resource "google_dns_managed_zone" "fail_ksk_rsasha1_second" {
  expect_failure = true
  attrs = {
    name     = "zone-f3"
    dns_name = "f3.example.com."
    dnssec_config = [{
      state = "on"
      default_key_specs = [
        { key_type = "zoneSigning", algorithm = "rsasha256", key_length = 1024 },
        { key_type = "keySigning", algorithm = "rsasha1", key_length = 2048 }
      ]
    }]
  }
}

resource "google_dns_managed_zone" "pass_dnssec_absent" {
  attrs = {
    name     = "zone-p4"
    dns_name = "p4.example.com."
  }
}

resource "google_dns_managed_zone" "pass_dnssec_null" {
  attrs = {
    name          = "zone-p5"
    dns_name      = "p5.example.com."
    dnssec_config = null
  }
}

resource "google_dns_managed_zone" "pass_dnssec_empty" {
  attrs = {
    name          = "zone-p6"
    dns_name      = "p6.example.com."
    dnssec_config = []
  }
}

resource "google_dns_managed_zone" "pass_key_specs_empty" {
  attrs = {
    name     = "zone-p7"
    dns_name = "p7.example.com."
    dnssec_config = [{
      state             = "on"
      default_key_specs = []
    }]
  }
}

resource "google_dns_managed_zone" "pass_key_specs_absent" {
  attrs = {
    name     = "zone-p8"
    dns_name = "p8.example.com."
    dnssec_config = [{
      state = "on"
    }]
  }
}
