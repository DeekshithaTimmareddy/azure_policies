policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 5.8.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "= 2.5.0"
    }
  }
}

  resource_policy "azapi_resource" "security_contact_email_configured" {
    locals {
      resource_type_raw = core::try(attrs.type, null)
      resource_type     = local.resource_type_raw == null ? "" : core::lower(local.resource_type_raw)
      api_resource      = core::split("@", local.resource_type)[0]
      api_version       = core::try(core::split("@", local.resource_type)[1], "")
      contact_name_raw  = core::try(attrs.name, null)
      contact_name      = local.contact_name_raw == null ? "" : core::lower(local.contact_name_raw)
      email_raw         = core::try(attrs.body.properties.emails, null)
      email             = local.email_raw == null ? "" : local.email_raw
      entries           = [for entry in core::split(",", local.email) : entry]
      valid_entries     = [for entry in local.entries : core::try(core::regex("^\\s*[^@\\s,]+@[^@\\s,]+\\.[^@\\s,]+\\s*$", entry), null) != null]
      invalid_count     = core::length([for valid in local.valid_entries : valid if !valid])
      is_valid          = core::try(core::regex("\\S", local.email), null) != null && local.invalid_count == 0
    }

    filter = local.api_resource == "microsoft.security/securitycontacts" && local.contact_name == "default"

    enforcement_level = "advisory"

    enforce {
      condition     = core::contains(["2020-01-01-preview", "2023-12-01-preview"], local.api_version) && local.is_valid
      error_message = "The default Microsoft Defender for Cloud AzAPI security contact must use API 2020-01-01-preview or 2023-12-01-preview and include one or more valid comma-separated email addresses in properties.emails."
    }
  }

resource_policy "azurerm_security_center_contact" "security_contact_email_configured" {
  locals {
    contact_name_raw = core::try(attrs.name, null)
    contact_name     = local.contact_name_raw == null ? "" : core::lower(local.contact_name_raw)
    email_raw        = core::try(attrs.email, null)
    email            = local.email_raw == null ? "" : local.email_raw
    entries          = [for entry in core::split(",", local.email) : entry]
    valid_entries    = [for entry in local.entries : core::try(core::regex("^\\s*[^@\\s,]+@[^@\\s,]+\\.[^@\\s,]+\\s*$", entry), null) != null]
    invalid_count    = core::length([for valid in local.valid_entries : valid if !valid])
    is_valid         = core::try(core::regex("\\S", local.email), null) != null && local.invalid_count == 0
  }

  filter = local.contact_name == "default"

  enforcement_level = "advisory"

  enforce {
    condition     = local.is_valid
    error_message = "The default Microsoft Defender for Cloud security contact must include one or more valid email addresses (comma-separated)."
  }
}
