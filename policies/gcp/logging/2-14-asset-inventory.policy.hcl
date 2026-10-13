# Copyright IBM Corp. 2026

# Ensure Cloud Asset Inventory Is Enabled

policy {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0.0, < 8.0.0"
    }
  }
}

input "asset-inventory-enforcement-level" {
  type    = string
  default = "advisory"
}

locals {
  all_services           = core::try([for s in core::getresources("google_project_service", {}) : s], [])
  cloudasset_services    = [for s in local.all_services : s if core::try(s.service, null) == "cloudasset.googleapis.com"]
  cloudasset_projects    = [for s in local.cloudasset_services : (core::try(s.project, null) == null ? "" : core::try(s.project, ""))]
  cloudasset_any_project = core::try(core::length([for p in local.cloudasset_projects : p if p == ""]), 0) > 0
  project_count          = core::try(core::length([for p in core::getresources("google_project", {}) : p]), 0)
}

resource_policy "google_project" "cloud_asset_api_enabled" {
  locals {
    pid_raw = core::try(attrs.project_id, null)
    pid     = local.pid_raw == null ? "" : local.pid_raw
    matched = local.cloudasset_any_project || (local.pid != "" && core::try(core::contains(local.cloudasset_projects, local.pid), false))
  }
  enforcement_level = input.asset-inventory-enforcement-level
  enforce {
    condition     = local.matched
    error_message = "Cloud Asset API (cloudasset.googleapis.com) must be enabled for project '${local.pid}' via google_project_service."
  }
}

resource_policy "google_project_service" "cloud_asset_api_enabled_in_config" {
  filter            = local.project_count == 0
  enforcement_level = input.asset-inventory-enforcement-level
  enforce {
    condition     = core::try(core::length(local.cloudasset_services), 0) > 0
    error_message = "No google_project_service enables cloudasset.googleapis.com; Cloud Asset Inventory must be enabled."
  }
}
