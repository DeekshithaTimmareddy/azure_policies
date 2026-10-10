policytest {
  targets = ["cis_azure_foundations_v6:7.12.policy.hcl"]
}

resource "azurerm_application_gateway" "pass_custom_tls12" {
  attrs = { ssl_policy = [{ policy_type = "Custom", min_protocol_version = "TLSv1_2" }] }
}

resource "azurerm_application_gateway" "pass_customv2_tls13" {
  attrs = { ssl_policy = [{ policy_type = "CustomV2", min_protocol_version = "TLSv1_3" }] }
}

resource "azurerm_application_gateway" "pass_customv2_tls12" {
  attrs = { ssl_policy = [{ policy_type = "CustomV2", min_protocol_version = "TLSv1_2" }] }
}

resource "azurerm_application_gateway" "pass_predefined_20170401s" {
  attrs = { ssl_policy = [{ policy_type = "Predefined", policy_name = "AppGwSslPolicy20170401S", min_protocol_version = null }] }
}

resource "azurerm_application_gateway" "pass_predefined_20220101" {
  attrs = { ssl_policy = [{ policy_type = "Predefined", policy_name = "AppGwSslPolicy20220101", min_protocol_version = null }] }
}

resource "azurerm_application_gateway" "pass_predefined_20220101s" {
  attrs = { ssl_policy = [{ policy_type = "Predefined", policy_name = "AppGwSslPolicy20220101S" }] }
}

resource "azurerm_application_gateway" "pass_default_policy_absent" {
  attrs = { name = "default" }
}

resource "azurerm_application_gateway" "pass_default_policy_empty" {
  attrs = { ssl_policy = [] }
}

resource "azurerm_application_gateway" "pass_unknown_policy_collection_deferred" {
  attrs = { ssl_policy = null }
}

resource "azurerm_application_gateway" "pass_custom_version_unknown_omitted_deferred" {
  attrs = { ssl_policy = [{ policy_type = "Custom" }] }
}

resource "azurerm_application_gateway" "pass_predefined_name_unknown_omitted_deferred" {
  attrs = { ssl_policy = [{ policy_type = "Predefined" }] }
}

resource "azurerm_application_gateway" "pass_disabled_protocols_modern_default" {
  attrs = { ssl_policy = [{ policy_type = null, policy_name = null, min_protocol_version = null, disabled_protocols = ["TLSv1_0", "TLSv1_1"] }] }
}

resource "azurerm_application_gateway" "pass_profile_tls12" {
  attrs = { ssl_profile = [{ name = "profile", ssl_policy = [{ policy_type = "Custom", min_protocol_version = "TLSv1_2" }] }] }
}

resource "azurerm_application_gateway" "pass_profile_tls13" {
  attrs = { ssl_profile = [{ name = "profile", ssl_policy = [{ policy_type = "CustomV2", min_protocol_version = "TLSv1_3" }] }] }
}

resource "azurerm_application_gateway" "pass_profile_predefined" {
  attrs = { ssl_profile = [{ name = "profile", ssl_policy = [{ policy_type = "Predefined", policy_name = "AppGwSslPolicy20220101S" }] }] }
}

resource "azurerm_application_gateway" "pass_profile_no_override" {
  attrs = { ssl_policy = [{ policy_type = "Predefined", policy_name = "AppGwSslPolicy20220101" }], ssl_profile = [{ name = "profile", ssl_policy = [] }] }
}

resource "azurerm_application_gateway" "pass_unknown_profiles_deferred" {
  attrs = { ssl_profile = null }
}

resource "azurerm_application_gateway" "pass_profile_unknown_version_deferred" {
  attrs = { ssl_profile = [{ name = "profile", ssl_policy = [{ policy_type = "CustomV2" }] }] }
}

resource "azurerm_application_gateway" "fail_custom_tls10" {
  expect_failure = true
  attrs = { ssl_policy = [{ policy_type = "Custom", min_protocol_version = "TLSv1_0" }] }
}

resource "azurerm_application_gateway" "fail_custom_tls11" {
  expect_failure = true
  attrs = { ssl_policy = [{ policy_type = "Custom", min_protocol_version = "TLSv1_1" }] }
}

resource "azurerm_application_gateway" "fail_custom_ssl2" {
  expect_failure = true
  attrs = { ssl_policy = [{ policy_type = "Custom", min_protocol_version = "SSLv2" }] }
}

resource "azurerm_application_gateway" "fail_custom_ssl3" {
  expect_failure = true
  attrs = { ssl_policy = [{ policy_type = "Custom", min_protocol_version = "SSLv3" }] }
}

resource "azurerm_application_gateway" "fail_custom_empty_version" {
  expect_failure = true
  attrs = { ssl_policy = [{ policy_type = "Custom", min_protocol_version = "" }] }
}

resource "azurerm_application_gateway" "fail_custom_null_version" {
  expect_failure = true
  attrs = { ssl_policy = [{ policy_type = "CustomV2", min_protocol_version = null }] }
}

resource "azurerm_application_gateway" "fail_custom_whitespace_version" {
  expect_failure = true
  attrs = { ssl_policy = [{ policy_type = "Custom", min_protocol_version = " " }] }
}

resource "azurerm_application_gateway" "fail_custom_unknown_literal_version" {
  expect_failure = true
  attrs = { ssl_policy = [{ policy_type = "Custom", min_protocol_version = "TLSv9_9" }] }
}

resource "azurerm_application_gateway" "fail_predefined_20150501" {
  expect_failure = true
  attrs = { ssl_policy = [{ policy_type = "Predefined", policy_name = "AppGwSslPolicy20150501" }] }
}

resource "azurerm_application_gateway" "fail_predefined_20170401" {
  expect_failure = true
  attrs = { ssl_policy = [{ policy_type = "Predefined", policy_name = "AppGwSslPolicy20170401" }] }
}

resource "azurerm_application_gateway" "fail_unverified_predefined_name" {
  expect_failure = true
  attrs = { ssl_policy = [{ policy_type = "Predefined", policy_name = "AppGwSslPolicy20990101" }] }
}

resource "azurerm_application_gateway" "fail_predefined_empty_name" {
  expect_failure = true
  attrs = { ssl_policy = [{ policy_type = "Predefined", policy_name = "" }] }
}

resource "azurerm_application_gateway" "fail_predefined_null_name" {
  expect_failure = true
  attrs = { ssl_policy = [{ policy_type = "Predefined", policy_name = null }] }
}

resource "azurerm_application_gateway" "fail_predefined_whitespace_name" {
  expect_failure = true
  attrs = { ssl_policy = [{ policy_type = "Predefined", policy_name = " " }] }
}

resource "azurerm_application_gateway" "fail_old_predefined_cannot_be_overridden_by_min" {
  expect_failure = true
  attrs = { ssl_policy = [{ policy_type = "Predefined", policy_name = "AppGwSslPolicy20150501", min_protocol_version = "TLSv1_2" }] }
}

resource "azurerm_application_gateway" "pass_custom_ignores_predefined_name" {
  attrs = { ssl_policy = [{ policy_type = "Custom", policy_name = "AppGwSslPolicy20150501", min_protocol_version = "TLSv1_2" }] }
}

resource "azurerm_application_gateway" "fail_profile_tls10" {
  expect_failure = true
  attrs = { ssl_profile = [{ name = "profile", ssl_policy = [{ policy_type = "Custom", min_protocol_version = "TLSv1_0" }] }] }
}

resource "azurerm_application_gateway" "fail_profile_tls11" {
  expect_failure = true
  attrs = { ssl_profile = [{ name = "profile", ssl_policy = [{ policy_type = "CustomV2", min_protocol_version = "TLSv1_1" }] }] }
}

resource "azurerm_application_gateway" "fail_profile_predefined_20150501" {
  expect_failure = true
  attrs = { ssl_profile = [{ name = "profile", ssl_policy = [{ policy_type = "Predefined", policy_name = "AppGwSslPolicy20150501" }] }] }
}

resource "azurerm_application_gateway" "fail_profile_predefined_20170401" {
  expect_failure = true
  attrs = { ssl_profile = [{ name = "profile", ssl_policy = [{ policy_type = "Predefined", policy_name = "AppGwSslPolicy20170401" }] }] }
}

resource "azurerm_application_gateway" "fail_profile_null_version" {
  expect_failure = true
  attrs = { ssl_profile = [{ name = "profile", ssl_policy = [{ policy_type = "Custom", min_protocol_version = null }] }] }
}

resource "azurerm_application_gateway" "fail_one_bad_profile_among_good" {
  expect_failure = true
  attrs = {
    ssl_profile = [
      { name = "good", ssl_policy = [{ policy_type = "Custom", min_protocol_version = "TLSv1_2" }] },
      { name = "bad", ssl_policy = [{ policy_type = "Custom", min_protocol_version = "TLSv1_1" }] }
    ]
  }
}

resource "azurerm_application_gateway" "fail_gateway_bad_with_good_profile" {
  expect_failure = true
  attrs = {
    ssl_policy = [{ policy_type = "Custom", min_protocol_version = "TLSv1_1" }]
    ssl_profile = [{ name = "good", ssl_policy = [{ policy_type = "Custom", min_protocol_version = "TLSv1_2" }] }]
  }
}

resource "azurerm_application_gateway" "fail_profile_bad_with_good_gateway" {
  expect_failure = true
  attrs = {
    ssl_policy = [{ policy_type = "Custom", min_protocol_version = "TLSv1_2" }]
    ssl_profile = [{ name = "bad", ssl_policy = [{ policy_type = "Custom", min_protocol_version = "TLSv1_0" }] }]
  }
}

resource "azurerm_application_gateway" "fail_known_bad_profile_among_unknown" {
  expect_failure = true
  attrs = {
    ssl_profile = [
      { name = "unknown", ssl_policy = null },
      { name = "bad", ssl_policy = [{ policy_type = "Custom", min_protocol_version = "TLSv1_1" }] }
    ]
  }
}

resource "azurerm_resource_group" "pass_unrelated" {
  attrs = { name = "rg-unrelated", location = "eastus" }
}
