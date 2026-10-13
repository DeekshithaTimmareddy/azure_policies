# Copyright IBM Corp. 2026

# Ensure That Sinks Are Configured for All Log Entries

policy {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0.0, < 8.0.0"
    }
  }
}

input "log-sinks-enforcement-level" {
  type    = string
  default = "advisory"
}

locals {
  all_sinks = core::flatten([
    core::try([for r in core::getresources("google_logging_project_sink", {}) : r], []),
    core::try([for r in core::getresources("google_logging_folder_sink", {}) : r], []),
    core::try([for r in core::getresources("google_logging_organization_sink", {}) : r], []),
    core::try([for r in core::getresources("google_logging_billing_account_sink", {}) : r], [])
  ])
  qualifying_sinks = [for s in local.all_sinks : s if core::try(s.disabled, null) != true && (core::try(s.filter, null) == null ? "" : s.filter) == "" && (core::try(s.destination, null) == null ? "" : core::trimspace(s.destination)) != "" && core::length(core::try([for exclusion in s.exclusions : exclusion if core::try(exclusion.disabled, null) != true], [])) == 0]
  has_all_logs_sink = core::length(local.qualifying_sinks) > 0
}

resource_policy "google_logging_project_sink" "sink_all_log_entries" {
  enforcement_level = input.log-sinks-enforcement-level
  enforce {
    condition     = local.has_all_logs_sink
    error_message = "At least one enabled logging sink must have an empty filter, a configured destination, and no enabled exclusions to export all log entries."
  }
}

resource_policy "google_logging_folder_sink" "sink_all_log_entries" {
  enforcement_level = input.log-sinks-enforcement-level
  enforce {
    condition     = local.has_all_logs_sink
    error_message = "At least one enabled logging sink must have an empty filter, a configured destination, and no enabled exclusions to export all log entries."
  }
}

resource_policy "google_logging_organization_sink" "sink_all_log_entries" {
  enforcement_level = input.log-sinks-enforcement-level
  enforce {
    condition     = local.has_all_logs_sink
    error_message = "At least one enabled logging sink must have an empty filter, a configured destination, and no enabled exclusions to export all log entries."
  }
}

resource_policy "google_logging_billing_account_sink" "sink_all_log_entries" {
  enforcement_level = input.log-sinks-enforcement-level
  enforce {
    condition     = local.has_all_logs_sink
    error_message = "At least one enabled logging sink must have an empty filter, a configured destination, and no enabled exclusions to export all log entries."
  }
}
