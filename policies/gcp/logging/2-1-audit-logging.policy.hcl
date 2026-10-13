# Copyright IBM Corp. 2026

# Ensure That Cloud Audit Logging Is Configured Properly

policy {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0.0, < 8.0.0"
    }
  }
}

input "audit-logging-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "google_project_iam_audit_config" "project_audit_config" {
  locals {
    service_raw = core::try(attrs.service, null)
    service     = local.service_raw == null ? "" : local.service_raw
    configs   = core::try([for c in attrs.audit_log_config : c], [])
    log_types = [for c in local.configs : core::try(c.log_type, null) == null ? "" : c.log_type]
    exempted         = core::flatten([for c in local.configs : core::try([for m in c.exempted_members : m], [])])
    no_exemptions    = core::length(local.exempted) == 0
    is_all_services  = local.service == "allServices"
    has_reads_writes = core::contains(local.log_types, "DATA_READ") && core::contains(local.log_types, "DATA_WRITE")
    compliant        = local.no_exemptions && (!local.is_all_services || local.has_reads_writes)
  }

  enforcement_level = input.audit-logging-enforcement-level
  enforce {
    condition     = local.compliant
    error_message = "Project-level audit config must have no exempted_members, and an allServices audit config must enable both DATA_READ and DATA_WRITE log types."
  }
}

resource_policy "google_folder_iam_audit_config" "folder_audit_config" {
  locals {
    service_raw = core::try(attrs.service, null)
    service     = local.service_raw == null ? "" : local.service_raw
    configs   = core::try([for c in attrs.audit_log_config : c], [])
    log_types = [for c in local.configs : core::try(c.log_type, null) == null ? "" : c.log_type]
    exempted         = core::flatten([for c in local.configs : core::try([for m in c.exempted_members : m], [])])
    no_exemptions    = core::length(local.exempted) == 0
    is_all_services  = local.service == "allServices"
    has_reads_writes = core::contains(local.log_types, "DATA_READ") && core::contains(local.log_types, "DATA_WRITE")
    compliant        = local.no_exemptions && (!local.is_all_services || local.has_reads_writes)
  }

  enforcement_level = input.audit-logging-enforcement-level
  enforce {
    condition     = local.compliant
    error_message = "Folder-level audit config must have no exempted_members, and an allServices audit config must enable both DATA_READ and DATA_WRITE log types."
  }
}

resource_policy "google_organization_iam_audit_config" "organization_audit_config" {
  locals {
    service_raw = core::try(attrs.service, null)
    service     = local.service_raw == null ? "" : local.service_raw
    configs   = core::try([for c in attrs.audit_log_config : c], [])
    log_types = [for c in local.configs : core::try(c.log_type, null) == null ? "" : c.log_type]
    exempted         = core::flatten([for c in local.configs : core::try([for m in c.exempted_members : m], [])])
    no_exemptions    = core::length(local.exempted) == 0
    is_all_services  = local.service == "allServices"
    has_reads_writes = core::contains(local.log_types, "DATA_READ") && core::contains(local.log_types, "DATA_WRITE")
    compliant        = local.no_exemptions && (!local.is_all_services || local.has_reads_writes)
  }

  enforcement_level = input.audit-logging-enforcement-level
  enforce {
    condition     = local.compliant
    error_message = "Organization-level audit config must have no exempted_members, and an allServices audit config must enable both DATA_READ and DATA_WRITE log types."
  }
}

resource_policy "google_project_iam_policy" "project_iam_policy_audit_config" {
  locals {
    policy_raw        = core::try(attrs.policy_data, null)
    policy_doc        = core::try(core::jsondecode(core::try(local.policy_raw, "")), {})
    audit_configs_raw = core::try(local.policy_doc.auditConfigs, null)
    audit_configs     = local.audit_configs_raw != null ? local.audit_configs_raw : []
  }

  locals {
    normalized_configs = [for config in local.audit_configs : {
      service   = core::try(config.service, "")
      log_types = core::try([for item in config.auditLogConfigs : core::try(item.logType, "")], [])
      exempted  = core::flatten(core::try([for item in config.auditLogConfigs : core::try([for member in item.exemptedMembers : member if member != null], [])], []))
    }]
  }

  locals {
    violations = [
      for config in local.normalized_configs : config
      if core::length(config.exempted) > 0 || (config.service == "allServices" && !(core::contains(config.log_types, "DATA_READ") && core::contains(config.log_types, "DATA_WRITE")))
    ]
  }

  enforcement_level = input.audit-logging-enforcement-level
  enforce {
    condition     = core::length(local.violations) == 0
    error_message = "Project IAM policy auditConfigs must have no exemptedMembers, and allServices must enable both DATA_READ and DATA_WRITE log types."
  }
}

resource_policy "google_folder_iam_policy" "folder_iam_policy_audit_config" {
  locals {
    policy_raw        = core::try(attrs.policy_data, null)
    policy_doc        = core::try(core::jsondecode(core::try(local.policy_raw, "")), {})
    audit_configs_raw = core::try(local.policy_doc.auditConfigs, null)
    audit_configs     = local.audit_configs_raw != null ? local.audit_configs_raw : []
  }

  locals {
    normalized_configs = [for config in local.audit_configs : {
      service   = core::try(config.service, "")
      log_types = core::try([for item in config.auditLogConfigs : core::try(item.logType, "")], [])
      exempted  = core::flatten(core::try([for item in config.auditLogConfigs : core::try([for member in item.exemptedMembers : member if member != null], [])], []))
    }]
  }

  locals {
    violations = [
      for config in local.normalized_configs : config
      if core::length(config.exempted) > 0 || (config.service == "allServices" && !(core::contains(config.log_types, "DATA_READ") && core::contains(config.log_types, "DATA_WRITE")))
    ]
  }

  enforcement_level = input.audit-logging-enforcement-level
  enforce {
    condition     = core::length(local.violations) == 0
    error_message = "Folder IAM policy auditConfigs must have no exemptedMembers, and allServices must enable both DATA_READ and DATA_WRITE log types."
  }
}

resource_policy "google_organization_iam_policy" "organization_iam_policy_audit_config" {
  locals {
    policy_raw        = core::try(attrs.policy_data, null)
    policy_doc        = core::try(core::jsondecode(core::try(local.policy_raw, "")), {})
    audit_configs_raw = core::try(local.policy_doc.auditConfigs, null)
    audit_configs     = local.audit_configs_raw != null ? local.audit_configs_raw : []
  }

  locals {
    normalized_configs = [for config in local.audit_configs : {
      service   = core::try(config.service, "")
      log_types = core::try([for item in config.auditLogConfigs : core::try(item.logType, "")], [])
      exempted  = core::flatten(core::try([for item in config.auditLogConfigs : core::try([for member in item.exemptedMembers : member if member != null], [])], []))
    }]
  }

  locals {
    has_default_config = core::length([
      for config in local.normalized_configs : config
      if config.service == "allServices" && core::contains(config.log_types, "DATA_READ") && core::contains(config.log_types, "DATA_WRITE")
    ]) > 0
    violations = [
      for config in local.normalized_configs : config
      if core::length(config.exempted) > 0 || (config.service == "allServices" && !(core::contains(config.log_types, "DATA_READ") && core::contains(config.log_types, "DATA_WRITE")))
    ]
  }

  enforcement_level = input.audit-logging-enforcement-level
  enforce {
    condition     = local.has_default_config && core::length(local.violations) == 0
    error_message = "Organization IAM policy auditConfigs must have no exemptedMembers, and allServices must enable both DATA_READ and DATA_WRITE log types."
  }
}
