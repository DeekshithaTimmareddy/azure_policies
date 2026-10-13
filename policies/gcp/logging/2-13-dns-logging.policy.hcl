# Copyright IBM Corp. 2026

# Ensure That Cloud DNS Logging Is Enabled for All VPC Networks

policy {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0.0, < 8.0.0"
    }
  }
}

input "dns-logging-enforcement-level" {
  type    = string
  default = "advisory"
}

locals {
  all_dns_policies = core::try([for policy in core::getresources("google_dns_policy", {}) : policy], [])

  logging_policy_urls = [
    for p in local.all_dns_policies : [
      for n in core::try([for x in p.networks : x], []) :
      core::try(n.network_url, null) == null ? "" : n.network_url
    ]
    if(core::try(p.enable_logging, null) == null ? false : p.enable_logging) == true
  ]
}

resource_policy "google_compute_network" "dns_logging_enabled" {
  locals {
    name_raw      = core::try(attrs.name, null)
    net_name      = local.name_raw == null ? "" : local.name_raw
    id_raw        = core::try(attrs.id, null)
    net_id        = local.id_raw == null ? "" : local.id_raw
    self_link_raw = core::try(attrs.self_link, null)
    net_self_link = local.self_link_raw == null ? "" : local.self_link_raw
    project_raw   = core::try(attrs.project, null)
    net_project   = local.project_raw == null ? "" : local.project_raw
    network_refs = [for reference in [
      local.net_id,
      local.net_self_link,
      local.net_project != "" && local.net_name != "" ? "projects/${local.net_project}/global/networks/${local.net_name}" : ""
    ] : reference if reference != ""]

    matching_policies = [
      for urls in local.logging_policy_urls : true
      if core::length([for url in urls : url if url != "" && core::length([for reference in local.network_refs : reference if url == reference || (core::startswith(reference, "projects/") && core::endswith(url, "/${reference}"))]) > 0]) > 0
    ]
  }

  enforcement_level = input.dns-logging-enforcement-level

  enforce {
    condition     = core::length(local.matching_policies) > 0
    error_message = "VPC network '${local.net_name}' must be attached to a google_dns_policy with enable_logging = true."
  }
}

resource_policy "google_dns_policy" "dns_policy_logging_enabled" {
  locals {
    networks_list  = core::try([for x in attrs.networks : x], [])
    logging_raw    = core::try(attrs.enable_logging, null)
    enable_logging = local.logging_raw == null ? false : local.logging_raw
  }

  enforcement_level = input.dns-logging-enforcement-level

  enforce {
    condition     = core::length(local.networks_list) == 0 || local.enable_logging == true
    error_message = "DNS policy attached to VPC networks must set enable_logging = true."
  }
}
