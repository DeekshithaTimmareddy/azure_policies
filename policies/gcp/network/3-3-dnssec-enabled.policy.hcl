# Copyright IBM Corp. 2026

# Ensure DNSSEC Is Enabled for Public Cloud DNS Zones

input "dnssec-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "google_dns_managed_zone" "dnssec_enabled_public_zones" {
  locals {
    visibility_raw = core::try(attrs.visibility, null)
    visibility     = local.visibility_raw == null ? "" : core::lower(local.visibility_raw)
    state_raw      = core::try(attrs.dnssec_config[0].state, null)
    state          = local.state_raw == null ? "off" : core::lower(local.state_raw)
  }

  filter = local.visibility != "private"

  enforcement_level = input.dnssec-enforcement-level

  enforce {
    condition     = local.state == "on"
    error_message = "Public Cloud DNS managed zones must have DNSSEC enabled (dnssec_config.state = \"on\")."
  }
}
