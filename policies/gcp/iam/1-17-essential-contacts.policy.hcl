# Copyright IBM Corp. 2026

# Ensure Essential Contacts Is Configured for the Organization

policy {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0.0, < 8.0.0"
    }
  }
}

input "essential-contacts-enforcement-level" {
  type    = string
  default = "advisory"
}

locals {
  all_contacts = core::getresources("google_essential_contacts_contact", {})
}

resource_policy "google_essential_contacts_contact" "essential_contacts_org" {
  locals {
    parent_raw = core::try(attrs.parent, null)
    parent     = local.parent_raw == null ? "" : local.parent_raw
    email      = core::try(core::trimspace(attrs.email), "")
    cats       = core::try([for c in attrs.notification_category_subscriptions : c if c != null], [])

    org_contacts = [for r in local.all_contacts : r if core::try(r.parent, null) == local.parent && local.parent != ""]
    covered = core::flatten([for r in local.org_contacts : core::try([for c in r.notification_category_subscriptions : c if c != null], []) if core::try(core::trimspace(core::try(r.email, "")), "") != ""])

    has_all     = core::contains(local.covered, "ALL")
    has_four    = core::contains(local.covered, "LEGAL") && core::contains(local.covered, "SECURITY") && core::contains(local.covered, "SUSPENSION") && core::contains(local.covered, "TECHNICAL")
    self_ok     = local.email != "" && core::length(local.cats) > 0
  }

  filter = core::try(core::startswith(local.parent, "organizations/"), false)

  enforcement_level = input.essential-contacts-enforcement-level

  enforce {
    condition     = local.self_ok && (local.has_all || local.has_four)
    error_message = "Essential Contacts for organization '${local.parent}' must have a non-empty email and, across the organization's contacts, cover ALL or each of LEGAL, SECURITY, SUSPENSION and TECHNICAL notification categories."
  }
}
