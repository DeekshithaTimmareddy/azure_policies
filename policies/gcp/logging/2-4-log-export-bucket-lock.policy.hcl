# Copyright IBM Corp. 2026

# Ensure That Retention Policies on Cloud Storage Buckets Used for Exporting Logs Are Configured Using Bucket Lock

policy {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 7.0.0, < 8.0.0"
    }
  }
}

input "log-export-bucket-lock-enforcement-level" {
  type    = string
  default = "advisory"
}

locals {
  bucket_lock_sinks = core::flatten([
    core::try([for s in core::getresources("google_logging_project_sink", {}) : s], []),
    core::try([for s in core::getresources("google_logging_folder_sink", {}) : s], []),
    core::try([for s in core::getresources("google_logging_organization_sink", {}) : s], []),
    core::try([for s in core::getresources("google_logging_billing_account_sink", {}) : s], [])
  ])
  sink_destinations = [for s in local.bucket_lock_sinks : core::try(s.destination, null)]
  sink_bucket_names = [for d in local.sink_destinations : core::split("storage.googleapis.com/", d)[1] if d != null && core::startswith(d, "storage.googleapis.com/")]
}

resource_policy "google_storage_bucket" "log_sink_bucket_locked_retention" {
  locals {
    name_raw         = core::try(attrs.name, null)
    name             = local.name_raw == null ? "" : local.name_raw
    rp_list          = core::try([for r in attrs.retention_policy : r], [])
    period_raw       = core::try(local.rp_list[0].retention_period, null)
    period           = local.period_raw == null ? "" : "${local.period_raw}"
    locked_raw       = core::try(local.rp_list[0].is_locked, null)
    locked           = local.locked_raw == null ? false : local.locked_raw
  }

  filter = local.name != "" && core::contains(local.sink_bucket_names, local.name)

  enforcement_level = input.log-export-bucket-lock-enforcement-level

  enforce {
    condition     = core::length(local.rp_list) > 0 && local.period != "" && local.period != "0" && local.locked == true
    error_message = "Storage bucket '${local.name}' is used as a log sink destination and must have a retention policy configured and locked (Bucket Lock)."
  }
}
