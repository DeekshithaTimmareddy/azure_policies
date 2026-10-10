policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

resource_policy "azurerm_virtual_network_gateway" "7_9" {
  filter = core::try(attrs.type, null) == "Vpn" && core::try(core::length([for b in attrs.vpn_client_configuration : b]), 0) > 0

  enforcement_level = "advisory"

  locals {
    configuration = core::try(attrs.vpn_client_configuration[0], {})
    auth_types    = core::try([for t in local.configuration.vpn_auth_types : t], null)
    known_non_aad = [for t in core::try([for a in local.auth_types : a], []) : t if t != null && t != "AAD"]
    auth_aad_only = local.auth_types == null ? true : (
      core::length(local.known_non_aad) == 0 &&
      (core::length([for t in local.auth_types : t if t == null]) > 0 || (core::length(local.auth_types) == 1 && core::contains(local.auth_types, "AAD")))
    )

    tenant   = core::try(local.configuration.aad_tenant == null ? "" : core::trimspace(local.configuration.aad_tenant), null)
    audience = core::try(local.configuration.aad_audience == null ? "" : core::trimspace(local.configuration.aad_audience), null)
    issuer   = core::try(local.configuration.aad_issuer == null ? "" : core::trimspace(local.configuration.aad_issuer), null)

    root_certificates = [for c in core::try([for x in local.configuration.root_certificate : x], []) : c if c != null]
    radius_servers    = [for r in core::try([for x in local.configuration.radius_server : x], []) : r if r != null]
    radius_address    = core::try(core::trimspace(local.configuration.radius_server_address), null)
  }

  enforce {
    condition     = local.auth_aad_only
    error_message = "VPN gateway point-to-site authentication types must be exactly [\"AAD\"]. Certificate, RADIUS, mixed, and empty authentication selections are not permitted."
  }

  enforce {
    condition     = (local.tenant == null || local.tenant != "") && (local.audience == null || local.audience != "") && (local.issuer == null || local.issuer != "")
    error_message = "VPN gateway point-to-site AAD authentication requires nonblank aad_tenant, aad_audience, and aad_issuer settings."
  }

  enforce {
    condition     = core::length(local.root_certificates) == 0 && core::length(local.radius_servers) == 0 && (local.radius_address == null || local.radius_address == "")
    error_message = "VPN gateway point-to-site AAD-only authentication must not configure root certificates or RADIUS servers."
  }
}
