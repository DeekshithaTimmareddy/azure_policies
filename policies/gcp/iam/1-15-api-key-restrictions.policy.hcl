# Copyright IBM Corp. 2026

# Ensure API Keys Are Restricted to Only APIs That an Application Needs Access To

policy {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0.0, < 8.0.0"
    }
  }
}

input "api-key-restrictions-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "google_apikeys_key" "api_key_restricted_to_needed_apis" {
  locals {
    # restrictions is a max-1 block; read its api_targets list
    api_targets  = core::try([for t in attrs.restrictions[0].api_targets : t if t != null], [])
    services     = [for t in local.api_targets : core::trimspace(core::try(t.service, null) == null ? "" : t.service)]
    has_targets  = core::length(local.services) > 0
    bad_services = [for s in local.services : s if s == "" || s == "cloudapis.googleapis.com"]
  }

  enforcement_level = input.api-key-restrictions-enforcement-level

  enforce {
    condition     = local.has_targets && core::length(local.bad_services) == 0
    error_message = "API key must restrict callable APIs via restrictions.api_targets, and must not target cloudapis.googleapis.com (Google Cloud APIs = all services)."
  }
}
