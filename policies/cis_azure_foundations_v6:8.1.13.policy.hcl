policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 5.8.0"
    }
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
