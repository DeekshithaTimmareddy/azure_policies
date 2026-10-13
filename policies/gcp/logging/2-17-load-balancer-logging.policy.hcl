# Copyright IBM Corp. 2026

# Ensure Logging Is Enabled for HTTP(S) Load Balancers

policy {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0.0, < 8.0.0"
    }
  }
}

input "load-balancer-logging-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "google_compute_backend_service" "http_lb_logging_enabled" {
  locals {
    protocol_raw = core::try(attrs.protocol, null)
    protocol     = local.protocol_raw == null ? "" : local.protocol_raw
    enable_raw   = core::try(attrs.log_config[0].enable, null)
    enable       = local.enable_raw == null ? false : local.enable_raw
    rate_raw     = core::try(attrs.log_config[0].sample_rate, null)
    rate         = local.rate_raw == null ? 1.0 : local.rate_raw
  }
  filter            = !core::contains(["TCP", "SSL", "UDP", "UNSPECIFIED"], local.protocol)
  enforcement_level = input.load-balancer-logging-enforcement-level
  enforce {
    condition     = local.enable == true && local.rate > 0
    error_message = "HTTP(S) load balancer backend service must have log_config.enable = true with a sample_rate greater than 0."
  }
}

resource_policy "google_compute_region_backend_service" "http_lb_logging_enabled" {
  locals {
    protocol_raw = core::try(attrs.protocol, null)
    protocol     = local.protocol_raw == null ? "" : local.protocol_raw
    enable_raw   = core::try(attrs.log_config[0].enable, null)
    enable       = local.enable_raw == null ? false : local.enable_raw
    rate_raw     = core::try(attrs.log_config[0].sample_rate, null)
    rate         = local.rate_raw == null ? 1.0 : local.rate_raw
  }
  filter            = !core::contains(["TCP", "SSL", "UDP", "UNSPECIFIED"], local.protocol)
  enforcement_level = input.load-balancer-logging-enforcement-level
  enforce {
    condition     = local.enable == true && local.rate > 0
    error_message = "HTTP(S) load balancer regional backend service must have log_config.enable = true with a sample_rate greater than 0."
  }
}
