policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

resource_policy "azurerm_application_gateway" "7_12" {
  enforcement_level = "advisory"

  locals {
    policies = core::concat(
      core::try([for p in attrs.ssl_policy : p if p != null], []),
      core::flatten(core::try([
        for profile in attrs.ssl_profile : core::try([for p in profile.ssl_policy : p if p != null], [])
      ], []))
    )
    normalized_policies = [
      for p in local.policies : {
        type = core::try(p.policy_type == null ? "" : p.policy_type, null)
        version = core::try(p.min_protocol_version == null ? "" : p.min_protocol_version, null)
        name = core::try(p.policy_name == null ? "" : p.policy_name, null)
      }
    ]
    noncompliant_policies = [
      for p in local.normalized_policies : p
      if (
        p.type == "Predefined" ?
        (p.name == null ? false : !core::contains(["AppGwSslPolicy20170401S", "AppGwSslPolicy20220101", "AppGwSslPolicy20220101S"], p.name)) :
        (p.type == "Custom" || p.type == "CustomV2" ?
          (p.version == null ? false : !core::contains(["TLSv1_2", "TLSv1_3"], p.version)) :
          ((p.version == null || p.version == "" ? false : !core::contains(["TLSv1_2", "TLSv1_3"], p.version)) ||
            (p.name == null || p.name == "" ? false : !core::contains(["AppGwSslPolicy20170401S", "AppGwSslPolicy20220101", "AppGwSslPolicy20220101S"], p.name)))
        )
      )
    ]
  }

  enforce {
    condition     = core::length(local.noncompliant_policies) == 0
    error_message = "Application Gateway and SSL profile policies must require TLSv1_2 or TLSv1_3, or use a verified TLS 1.2 predefined policy: AppGwSslPolicy20170401S, AppGwSslPolicy20220101, or AppGwSslPolicy20220101S."
  }
}
