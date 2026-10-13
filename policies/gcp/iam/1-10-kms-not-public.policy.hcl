# Copyright IBM Corp. 2026

# Ensure That Cloud KMS Cryptokeys Are Not Anonymously or Publicly Accessible

policy {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0.0, < 8.0.0"
    }
  }
}

input "kms-not-public-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "google_kms_crypto_key_iam_member" "kms_key_member_not_public" {
  locals {
    member_raw = core::try(attrs.member, null)
    member     = local.member_raw == null ? "" : local.member_raw
    is_public  = core::contains(["allUsers", "allAuthenticatedUsers"], core::trimspace(local.member))
  }

  enforcement_level = input.kms-not-public-enforcement-level

  enforce {
    condition     = !local.is_public
    error_message = "KMS crypto key IAM member must not be allUsers or allAuthenticatedUsers (found '${local.member}')."
  }
}

resource_policy "google_kms_crypto_key_iam_binding" "kms_key_binding_not_public" {
  locals {
    members        = core::try([for m in attrs.members : m if m != null], [])
    public_members = [for m in local.members : m if core::contains(["allUsers", "allAuthenticatedUsers"], core::trimspace(m))]
  }

  enforcement_level = input.kms-not-public-enforcement-level

  enforce {
    condition     = core::length(local.public_members) == 0
    error_message = "KMS crypto key IAM binding must not include allUsers or allAuthenticatedUsers (found: ${core::join(", ", local.public_members)})."
  }
}

resource_policy "google_kms_crypto_key_iam_policy" "kms_key_policy_not_public" {
  locals {
    policy_raw   = core::try(attrs.policy_data, null)
    policy_doc   = core::try(core::jsondecode(core::try(local.policy_raw, "")), {})
    bindings_raw = core::try(local.policy_doc.bindings, null)
    bindings     = local.bindings_raw != null ? local.bindings_raw : []
  }

  locals {
    normalized_bindings = [for binding in local.bindings : {
      members_safe = core::try(binding.members, null) != null ? [for member in binding.members : member if member != null] : []
    }]
  }

  locals {
    public_bindings = [
      for binding in local.normalized_bindings : binding
      if core::length([for member in binding.members_safe : member if core::contains(["allUsers", "allAuthenticatedUsers"], core::trimspace(member))]) > 0
    ]
  }

  enforcement_level = input.kms-not-public-enforcement-level

  enforce {
    condition     = core::length(local.public_bindings) == 0
    error_message = "KMS crypto key IAM policy must not grant access to allUsers or allAuthenticatedUsers."
  }
}
