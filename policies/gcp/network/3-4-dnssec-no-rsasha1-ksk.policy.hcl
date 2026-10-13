# Copyright IBM Corp. 2026

# Ensure RSASHA1 Is Not Used for the Key-Signing Key in Cloud DNS DNSSEC

policy {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0.0, < 8.0.0"
    }
  }
}

input "dnssec-ksk-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "google_dns_managed_zone" "ksk_not_rsasha1" {
  locals {
    dnssec_blocks = core::try([for b in attrs.dnssec_config : b], [])
    key_specs     = core::flatten([for b in local.dnssec_blocks : core::try([for s in b.default_key_specs : s], [])])
    bad_ksks      = [for s in local.key_specs : s if core::try(core::lower(s.key_type), "") == "keysigning" && core::try(core::lower(s.algorithm), "") == "rsasha1"]
  }

  enforcement_level = input.dnssec-ksk-enforcement-level

  enforce {
    condition     = core::length(local.bad_ksks) == 0
    error_message = "Cloud DNS managed zone DNSSEC key-signing key must not use RSASHA1."
  }
}
