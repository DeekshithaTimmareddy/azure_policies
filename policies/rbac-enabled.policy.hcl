resource_policy "azurerm_key_vault" "rbac_authorization_enabled" {
    enforcement_level = "advisory"

    locals {
        rbac_new_raw    = core::try(attrs.rbac_authorization_enabled, null)
        rbac_legacy_raw = core::try(attrs.enable_rbac_authorization, null)
        rbac_enabled    = local.rbac_new_raw == true || local.rbac_legacy_raw == true
    }

    enforce {
        condition     = local.rbac_enabled
        error_message = "Key Vault must use the Azure RBAC permission model (rbac_authorization_enabled, or enable_rbac_authorization on provider <5.0.0, must be set to true)."
    }
}
