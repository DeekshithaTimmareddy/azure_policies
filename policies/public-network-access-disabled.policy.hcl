resource_policy "azurerm_key_vault" "public_network_access_disabled" {
    locals {
        public_access_raw = core::try(attrs.public_network_access_enabled, null)
        public_access = local.public_access_raw == null ? true : local.public_access_raw
    }

    enforcement_level = "advisory"

    enforce {
        condition     = local.public_access == false
        error_message = "Key Vault must have public network access disabled (public_network_access_enabled = false)."
    }
}
