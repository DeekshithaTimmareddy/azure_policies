resource_policy "azurerm_security_center_setting" "endpoint_protection_on" {

  locals {
    setting_name_raw = core::try(attrs.setting_name, null)
    setting_name     = local.setting_name_raw == null ? "" : local.setting_name_raw
    in_scope         = core::contains(["WDATP", "WDATP_UNIFIED_SOLUTION"], local.setting_name)

    enabled_raw = core::try(attrs.enabled, null)
    enabled     = local.enabled_raw == null ? false : local.enabled_raw
  }

  filter = local.in_scope

  enforcement_level = "advisory"

  enforce {
    condition     = local.enabled == true
    error_message = "Endpoint protection (setting_name WDATP / WDATP_UNIFIED_SOLUTION) must be enabled=true."
  }
}
