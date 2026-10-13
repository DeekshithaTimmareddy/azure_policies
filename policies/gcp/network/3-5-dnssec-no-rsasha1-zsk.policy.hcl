# Copyright IBM Corp. 2026

# Ensure RSASHA1 Is Not Used for the Zone-Signing Key in Cloud DNS DNSSEC

policy {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0.0, < 8.0.0"
    }
  }
}

input "dnssec-zsk-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "google_dns_managed_zone" "zsk_not_rsasha1" {
  locals {
    dnssec_blocks  = core::try([for d in attrs.dnssec_config : d], [])
    key_specs      = core::flatten([for d in local.dnssec_blocks : core::try([for k in d.default_key_specs : k], [])])
    zsk_algorithms = [for k in local.key_specs : (core::try(k.algorithm, null) == null ? "" : k.algorithm) if core::try(core::lower(k.key_type), "") == "zonesigning"]
    rsasha1_zsks   = [for a in local.zsk_algorithms : a if core::lower(a) == "rsasha1"]
  }

  enforcement_level = input.dnssec-zsk-enforcement-level

  enforce {
    condition     = core::length(local.rsasha1_zsks) == 0
    error_message = "Cloud DNS managed zone '${core::try(attrs.name, "")}' uses RSASHA1 for a DNSSEC zone-signing key; use RSASHA256, RSASHA512, ECDSAP256SHA256 or ECDSAP384SHA384."
  }
}
