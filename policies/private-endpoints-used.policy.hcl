locals {
  all_private_endpoints = core::getresources("azurerm_private_endpoint", {})
}

resource_policy "azurerm_key_vault" "require_private_endpoint" {
  locals {
    kv_id_raw = core::try(attrs.id, null)
    kv_id     = local.kv_id_raw == null ? "" : local.kv_id_raw

    matching = [
      for pe in local.all_private_endpoints : pe
      if local.kv_id != "" && core::length([
        for c in core::try([for sc in pe.private_service_connection : sc], []) : c
        if (core::try(c.private_connection_resource_id, null) == null ? "" : core::try(c.private_connection_resource_id, null)) == local.kv_id
      ]) > 0
    ]

    has_private_endpoint = core::length(local.matching) > 0
  }

  enforcement_level = "advisory"

  enforce {
    condition     = local.has_private_endpoint
    error_message = "Key Vault must be accessed via a Private Endpoint (an azurerm_private_endpoint with a private_service_connection whose private_connection_resource_id targets this vault); none found."
  }
}
