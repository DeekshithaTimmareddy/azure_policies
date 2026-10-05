# Copyright IBM Corp. 2026

# Ensure that 'security defaults' is Enabled in Microsoft Entra ID

policy {
  required_providers {
    msgraph = {
      source  = "Microsoft/msgraph"
      version = ">= 0.5.0, < 1.0.0"
    }
  }
}

input "security-defaults-enabled-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "msgraph_update_resource" "security_defaults_enabled" {
  filter = core::lower(core::trim(core::try(attrs.url, ""), "/")) == "policies/identitysecuritydefaultsenforcementpolicy"

  enforcement_level = input.security-defaults-enabled-enforcement-level

  enforce {
    condition     = core::try(attrs.body.isEnabled, false) == true
    error_message = "Microsoft Entra ID security defaults must be enabled by setting body.isEnabled to true."
  }
}
