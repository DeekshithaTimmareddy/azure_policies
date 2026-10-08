# Copyright IBM Corp. 2026

# CIS Azure Foundations v6.0.0 - 6.1.2.11

policy {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = ">= 4.0.0, < 6.0.0"
        }
    }
}

input "service-health-alert-enforcement-level" {
    type = string
    default = "advisory"
}

resource_policy "azurerm_monitor_activity_log_alert" "6_1_2_11" {
    filter = core::try(core::lower(core::trimspace(attrs.criteria[0].category)), "") == "servicehealth"

    enforcement_level = input.service-health-alert-enforcement-level

    locals {
        criteria = core::try(attrs.criteria[0], {})

        is_enabled = core::try(attrs.enabled, true) != false

        known_scopes        = [for s in core::try([for x in attrs.scopes : x], []) : core::lower(core::trimsuffix(core::trimspace(s), "/")) if s != null]
        subscription_scoped = core::length(local.known_scopes) == 0 || core::length([for s in local.known_scopes : s if core::try(core::regex("^/subscriptions/[^/]+$", s), null) != null]) > 0

        has_action_group = core::length([
            for a in core::try([for x in attrs.action : x], []) : a
            if core::try(core::trimspace(a.action_group_id), "unknown") != ""
        ]) > 0

        service_health = core::try([for h in local.criteria.service_health : h], [])
        all_services   = core::length([for h in local.service_health : h if core::length(core::try([for s in h.services : s], [])) > 0]) == 0

        required_events = ["incident", "maintenance", "informational", "actionrequired", "security"]
        all_events = core::length([
            for h in local.service_health : h
            if core::length(core::try([for e in h.events : e], [])) > 0 && core::length([
                for required in local.required_events : required
                if !core::contains(core::try([for e in h.events : core::lower(core::trimspace(e))], []), required)
            ]) > 0
        ]) == 0

        narrowing_filters = core::concat([
            for k in [
                "operation_name", "caller", "level", "levels", "status", "statuses", "sub_status", "sub_statuses",
                "resource_group", "resource_groups", "resource_id", "resource_ids",
                "resource_provider", "resource_providers", "resource_type", "resource_types",
                "recommendation_type", "recommendation_category", "recommendation_impact",
            ] : k
            if core::try(core::trimspace(local.criteria[k]), "") != "" || core::length(core::try([for v in local.criteria[k] : v], [])) > 0
        ], [
            for k in ["current", "previous", "reason"] : "resource_health.${k}"
            if core::length([
                for h in core::try([for r in local.criteria.resource_health : r], []) : h
                if core::length(core::try([for v in h[k] : v], [])) > 0
            ]) > 0
        ])
    }

    enforce {
        condition     = local.is_enabled
        error_message = "The Service Health activity log alert must be enabled."
    }

    enforce {
        condition     = local.subscription_scoped
        error_message = "The Service Health activity log alert must be scoped to a subscription."
    }

    enforce {
        condition     = local.has_action_group
        error_message = "The Service Health activity log alert must notify an action group."
    }

    enforce {
        condition     = local.all_services
        error_message = "The Service Health activity log alert must cover all services. Remove the service_health.services restriction."
    }

    enforce {
        condition     = local.all_events
        error_message = "The Service Health activity log alert must cover all event types. Omit service_health.events or include Incident, Maintenance, Informational, ActionRequired and Security."
    }

    enforce {
        condition     = core::length(local.narrowing_filters) == 0
        error_message = "The Service Health activity log alert must not narrow event coverage with additional criteria filters. Remove: ${core::join(", ", local.narrowing_filters)}."
    }
}
