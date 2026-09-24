resource_policy "azurerm_key_vault_key" "8_3_9" {
  locals {
    rotation_policy_raw = core::try([for b in attrs.rotation_policy : b], [])
    has_rotation_policy = core::try(core::length(local.rotation_policy_raw), 0) > 0

    automatic_raw = local.has_rotation_policy ? core::try([for b in local.rotation_policy_raw[0].automatic : b], []) : []
    has_automatic = core::try(core::length(local.automatic_raw), 0) > 0

    time_after_creation_raw = local.has_automatic ? core::try(local.automatic_raw[0].time_after_creation, null) : null
    time_before_expiry_raw  = local.has_automatic ? core::try(local.automatic_raw[0].time_before_expiry, null) : null

    time_after_creation = local.time_after_creation_raw == null ? "" : local.time_after_creation_raw
    time_before_expiry  = local.time_before_expiry_raw == null ? "" : local.time_before_expiry_raw

    has_rotation_trigger = local.time_after_creation != "" || local.time_before_expiry != ""
  }

  enforcement_level = "advisory"

  enforce {
    condition     = local.has_rotation_policy && local.has_automatic && local.has_rotation_trigger
    error_message = "azurerm_key_vault_key must have automatic key rotation enabled: define a rotation_policy with an automatic block whose time_after_creation or time_before_expiry sets a rotation schedule."
  }
}
