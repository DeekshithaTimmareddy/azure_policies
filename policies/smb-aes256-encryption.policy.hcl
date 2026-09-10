# Copyright IBM Corp. 2026

# Ensure 'SMB channel encryption' is Set to 'AES-256-GCM' or Higher for SMB file shares
policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "smb-aes256-encryption-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_storage_account" "require_smb_aes256_encryption" {
  locals {
    account_kind_raw  = core::try(attrs.account_kind, null)
    account_kind      = local.account_kind_raw == null ? "StorageV2" : local.account_kind_raw
    is_supported_kind = core::contains(["StorageV2", "FileStorage"], local.account_kind)

    share_properties_raw = core::try(attrs.share_properties, null)
    smb_raw              = core::try(attrs.share_properties[0].smb, core::try(attrs.share_properties.smb, null))
    encryption_types_raw = core::try(local.smb_raw[0].channel_encryption_type, core::try(local.smb_raw.channel_encryption_type, null))
    encryption_types     = local.encryption_types_raw != null ? local.encryption_types_raw : []
    has_aes_256_gcm      = core::contains(local.encryption_types, "AES-256-GCM")
    weak_encryption_types = [for encryption_type in local.encryption_types : encryption_type
      if encryption_type == "AES-128-CCM" || encryption_type == "AES-128-GCM"
    ]
  }

  enforcement_level = input.smb-aes256-encryption-enforcement-level
  enforce {
    condition     = !local.is_supported_kind || (local.has_aes_256_gcm && core::length(local.weak_encryption_types) == 0)
    error_message = "Storage accounts with SMB file shares must allow AES-256-GCM channel encryption and must not allow AES-128-CCM or AES-128-GCM. Configure share_properties.smb.channel_encryption_type with only AES-256-GCM."
  }
}
