# Copyright IBM Corp. 2026

# Ensure KMS Encryption Keys Are Rotated Within a Period of 90 Days

policy {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0.0, < 8.0.0"
    }
  }
}

input "kms-key-rotation-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "google_kms_crypto_key" "kms_key_rotation_90_days" {
  locals {
    rp_raw   = core::try(attrs.rotation_period, null)
    rotation = local.rp_raw == null ? "" : local.rp_raw
    is_unset = local.rotation == ""
    unit     = local.is_unset ? "" : (core::endswith(local.rotation, "s") ? "s" : (core::endswith(local.rotation, "m") ? "m" : (core::endswith(local.rotation, "h") ? "h" : (core::endswith(local.rotation, "d") ? "d" : ""))))
    factor   = local.unit == "s" ? 1 : (local.unit == "m" ? 60 : (local.unit == "h" ? 3600 : (local.unit == "d" ? 86400 : 0)))
    num_str  = local.unit == "" ? "" : core::try(core::split(".", core::try(core::split(local.unit, local.rotation)[0], ""))[0], "")
    num      = core::try(core::parseint(local.num_str, 10), -1)
    seconds  = (local.num < 0 || local.factor == 0) ? -1 : local.num * local.factor
    has_frac = core::try(core::length(core::split(".", local.rotation)) > 1, false)
    within   = local.seconds >= 0 && !local.has_frac && local.seconds <= 7776000
  }

  enforcement_level = input.kms-key-rotation-enforcement-level

  enforce {
    condition     = !local.is_unset && local.within
    error_message = "KMS crypto key must set rotation_period to 90 days (7776000s) or less."
  }
}
