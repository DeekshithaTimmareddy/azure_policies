# Copyright IBM Corp. 2026

# Ensure That There Are Only GCP-Managed Service Account Keys for Each Service Account

policy {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0.0, < 8.0.0"
    }
  }
}

input "service-account-keys-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "google_service_account_key" "only_gcp_managed_keys" {
  locals {
    sa_raw          = core::try(attrs.service_account_id, null)
    service_account = local.sa_raw != null ? local.sa_raw : "<unknown>"
  }

  enforcement_level = input.service-account-keys-enforcement-level
  enforce {
    condition     = false
    error_message = "User-managed service account key found for service account '${local.service_account}'. Only GCP-managed keys are allowed, so remove this google_service_account_key."
  }
}
