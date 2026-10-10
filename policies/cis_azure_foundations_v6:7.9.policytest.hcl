policytest {
  targets = ["cis_azure_foundations_v6:7.9.policy.hcl"]
}

resource "azurerm_virtual_network_gateway" "pass_aad_only" {
  attrs = {
    type = "Vpn"
    vpn_client_configuration = [{
      vpn_auth_types = ["AAD"]
      aad_tenant     = "https://login.microsoftonline.com/11111111-1111-1111-1111-111111111111/"
      aad_audience   = "41b23e61-6c1e-4545-b367-cd054e0ed4b4"
      aad_issuer     = "https://sts.windows.net/11111111-1111-1111-1111-111111111111/"
    }]
  }
}

resource "azurerm_virtual_network_gateway" "pass_auth_absent_deferred" {
  attrs = {
    type = "Vpn"
    vpn_client_configuration = [{ aad_tenant = "tenant", aad_audience = "audience", aad_issuer = "issuer" }]
  }
}

resource "azurerm_virtual_network_gateway" "pass_auth_null_deferred" {
  attrs = {
    type = "Vpn"
    vpn_client_configuration = [{ vpn_auth_types = null, aad_tenant = "tenant", aad_audience = "audience", aad_issuer = "issuer" }]
  }
}

resource "azurerm_virtual_network_gateway" "pass_auth_unknown_element_deferred" {
  attrs = {
    type = "Vpn"
    vpn_client_configuration = [{ vpn_auth_types = [null] }]
  }
}

resource "azurerm_virtual_network_gateway" "pass_aad_and_unknown_element_deferred" {
  attrs = {
    type = "Vpn"
    vpn_client_configuration = [{ vpn_auth_types = ["AAD", null] }]
  }
}

resource "azurerm_virtual_network_gateway" "fail_aad_settings_known_null" {
  expect_failure = true
  attrs = {
    type = "Vpn"
    vpn_client_configuration = [{ vpn_auth_types = ["AAD"], aad_tenant = null, aad_audience = null, aad_issuer = null }]
  }
}

resource "azurerm_virtual_network_gateway" "pass_aad_settings_absent_deferred" {
  attrs = {
    type = "Vpn"
    vpn_client_configuration = [{ vpn_auth_types = ["AAD"] }]
  }
}

resource "azurerm_virtual_network_gateway" "pass_audience_unknown_omitted_deferred" {
  attrs = {
    type = "Vpn"
    vpn_client_configuration = [{ vpn_auth_types = ["AAD"], aad_tenant = "tenant", aad_issuer = "issuer" }]
  }
}

resource "azurerm_virtual_network_gateway" "fail_known_null_tenant" {
  expect_failure = true
  attrs = {
    type = "Vpn"
    vpn_client_configuration = [{ vpn_auth_types = ["AAD"], aad_tenant = null, aad_audience = "audience", aad_issuer = "issuer" }]
  }
}

resource "azurerm_virtual_network_gateway" "fail_known_null_audience" {
  expect_failure = true
  attrs = {
    type = "Vpn"
    vpn_client_configuration = [{ vpn_auth_types = ["AAD"], aad_tenant = "tenant", aad_audience = null, aad_issuer = "issuer" }]
  }
}

resource "azurerm_virtual_network_gateway" "fail_known_null_issuer" {
  expect_failure = true
  attrs = {
    type = "Vpn"
    vpn_client_configuration = [{ vpn_auth_types = ["AAD"], aad_tenant = "tenant", aad_audience = "audience", aad_issuer = null }]
  }
}

resource "azurerm_virtual_network_gateway" "pass_aad_settings_surrounding_whitespace" {
  attrs = {
    type = "Vpn"
    vpn_client_configuration = [{ vpn_auth_types = ["AAD"], aad_tenant = " tenant ", aad_audience = " audience ", aad_issuer = " issuer " }]
  }
}

resource "azurerm_virtual_network_gateway" "pass_empty_alternative_settings" {
  attrs = {
    type = "Vpn"
    vpn_client_configuration = [{ vpn_auth_types = ["AAD"], root_certificate = [], radius_server = [], radius_server_address = "" }]
  }
}

resource "azurerm_virtual_network_gateway" "pass_null_alternative_settings_deferred" {
  attrs = {
    type = "Vpn"
    vpn_client_configuration = [{ vpn_auth_types = ["AAD"], root_certificate = null, radius_server = null, radius_server_address = null }]
  }
}

resource "azurerm_virtual_network_gateway" "pass_revoked_certificate_not_authentication" {
  attrs = {
    type = "Vpn"
    vpn_client_configuration = [{ vpn_auth_types = ["AAD"], revoked_certificate = [{ name = "revoked", thumbprint = "0000000000000000000000000000000000000000" }] }]
  }
}

resource "azurerm_virtual_network_gateway" "pass_no_p2s_block_out_of_scope" {
  attrs = { type = "Vpn" }
}

resource "azurerm_virtual_network_gateway" "pass_empty_p2s_block_out_of_scope" {
  attrs = { type = "Vpn", vpn_client_configuration = [] }
}

resource "azurerm_virtual_network_gateway" "pass_null_p2s_block_deferred" {
  attrs = { type = "Vpn", vpn_client_configuration = null }
}

resource "azurerm_virtual_network_gateway" "pass_expressroute_with_p2s_out_of_scope" {
  attrs = { type = "ExpressRoute", vpn_client_configuration = [{ vpn_auth_types = ["Certificate"] }] }
}

resource "azurerm_virtual_network_gateway" "pass_unknown_type_deferred" {
  attrs = { type = null, vpn_client_configuration = [{ vpn_auth_types = ["Certificate"] }] }
}

resource "azurerm_virtual_network_gateway" "fail_certificate_only" {
  expect_failure = true
  attrs = { type = "Vpn", vpn_client_configuration = [{ vpn_auth_types = ["Certificate"] }] }
}

resource "azurerm_virtual_network_gateway" "fail_radius_only" {
  expect_failure = true
  attrs = { type = "Vpn", vpn_client_configuration = [{ vpn_auth_types = ["Radius"] }] }
}

resource "azurerm_virtual_network_gateway" "fail_aad_and_certificate" {
  expect_failure = true
  attrs = { type = "Vpn", vpn_client_configuration = [{ vpn_auth_types = ["AAD", "Certificate"] }] }
}

resource "azurerm_virtual_network_gateway" "fail_aad_and_radius" {
  expect_failure = true
  attrs = { type = "Vpn", vpn_client_configuration = [{ vpn_auth_types = ["AAD", "Radius"] }] }
}

resource "azurerm_virtual_network_gateway" "fail_all_auth_types" {
  expect_failure = true
  attrs = { type = "Vpn", vpn_client_configuration = [{ vpn_auth_types = ["AAD", "Certificate", "Radius"] }] }
}

resource "azurerm_virtual_network_gateway" "fail_known_certificate_with_unknown_type" {
  expect_failure = true
  attrs = { type = "Vpn", vpn_client_configuration = [{ vpn_auth_types = [null, "Certificate"] }] }
}

resource "azurerm_virtual_network_gateway" "fail_known_empty_auth_types" {
  expect_failure = true
  attrs = {
    type = "Vpn"
    vpn_client_configuration = [{ vpn_auth_types = [], aad_tenant = "tenant", aad_audience = "audience", aad_issuer = "issuer" }]
  }
}

resource "azurerm_virtual_network_gateway" "fail_empty_tenant" {
  expect_failure = true
  attrs = { type = "Vpn", vpn_client_configuration = [{ vpn_auth_types = ["AAD"], aad_tenant = "", aad_audience = "audience", aad_issuer = "issuer" }] }
}

resource "azurerm_virtual_network_gateway" "fail_whitespace_tenant" {
  expect_failure = true
  attrs = { type = "Vpn", vpn_client_configuration = [{ vpn_auth_types = ["AAD"], aad_tenant = " \t ", aad_audience = "audience", aad_issuer = "issuer" }] }
}

resource "azurerm_virtual_network_gateway" "fail_empty_audience" {
  expect_failure = true
  attrs = { type = "Vpn", vpn_client_configuration = [{ vpn_auth_types = ["AAD"], aad_tenant = "tenant", aad_audience = "", aad_issuer = "issuer" }] }
}

resource "azurerm_virtual_network_gateway" "fail_whitespace_audience" {
  expect_failure = true
  attrs = { type = "Vpn", vpn_client_configuration = [{ vpn_auth_types = ["AAD"], aad_tenant = "tenant", aad_audience = " \t ", aad_issuer = "issuer" }] }
}

resource "azurerm_virtual_network_gateway" "fail_empty_issuer" {
  expect_failure = true
  attrs = { type = "Vpn", vpn_client_configuration = [{ vpn_auth_types = ["AAD"], aad_tenant = "tenant", aad_audience = "audience", aad_issuer = "" }] }
}

resource "azurerm_virtual_network_gateway" "fail_whitespace_issuer" {
  expect_failure = true
  attrs = { type = "Vpn", vpn_client_configuration = [{ vpn_auth_types = ["AAD"], aad_tenant = "tenant", aad_audience = "audience", aad_issuer = " \t " }] }
}

resource "azurerm_virtual_network_gateway" "fail_no_auth_configured_known_defaults" {
  expect_failure = true
  attrs = {
    type = "Vpn"
    vpn_client_configuration = [{ vpn_auth_types = null, aad_tenant = "", aad_audience = "", aad_issuer = "" }]
  }
}

resource "azurerm_virtual_network_gateway" "fail_aad_with_root_certificate" {
  expect_failure = true
  attrs = {
    type = "Vpn"
    vpn_client_configuration = [{ vpn_auth_types = ["AAD"], root_certificate = [{ name = "root", public_cert_data = "synthetic-test-value" }] }]
  }
}

resource "azurerm_virtual_network_gateway" "fail_unknown_auth_with_root_certificate" {
  expect_failure = true
  attrs = {
    type = "Vpn"
    vpn_client_configuration = [{ vpn_auth_types = null, root_certificate = [{ name = "root", public_cert_data = "synthetic-test-value" }] }]
  }
}

resource "azurerm_virtual_network_gateway" "fail_aad_with_radius_block" {
  expect_failure = true
  attrs = {
    type = "Vpn"
    vpn_client_configuration = [{ vpn_auth_types = ["AAD"], radius_server = [{ address = "10.1.0.4", score = 1 }] }]
  }
}

resource "azurerm_virtual_network_gateway" "fail_unknown_auth_with_radius_block" {
  expect_failure = true
  attrs = {
    type = "Vpn"
    vpn_client_configuration = [{ vpn_auth_types = null, radius_server = [{ address = "10.1.0.4", score = 1 }] }]
  }
}

resource "azurerm_virtual_network_gateway" "fail_aad_with_legacy_radius_address" {
  expect_failure = true
  attrs = { type = "Vpn", vpn_client_configuration = [{ vpn_auth_types = ["AAD"], radius_server_address = "10.1.0.4" }] }
}

resource "azurerm_virtual_network_gateway" "fail_unknown_auth_with_legacy_radius_address" {
  expect_failure = true
  attrs = { type = "Vpn", vpn_client_configuration = [{ vpn_auth_types = null, radius_server_address = "10.1.0.4" }] }
}

resource "azurerm_resource_group" "pass_unrelated_resource_out_of_scope" {
  attrs = { name = "rg-unrelated", location = "eastus" }
}
