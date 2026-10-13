terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0.0, < 8.0.0"
    }
  }
}

variable "project_id" {
  type        = string
  description = "Disposable GCP project used for live policy tests."
}

variable "control" {
  type        = string
  description = "One logging control to test."
  default     = "sql"

  validation {
    condition     = contains(["sql", "ownership", "audit", "role", "firewall", "route", "network", "storage"], var.control)
    error_message = "Choose sql, ownership, audit, role, firewall, route, network, or storage."
  }
}

variable "phase" {
  type        = string
  description = "Use bootstrap, metric, then test so the log metric can propagate before its alert is created."
  default     = "bootstrap"

  validation {
    condition     = contains(["bootstrap", "metric", "test"], var.phase)
    error_message = "Choose bootstrap, metric, or test."
  }
}

provider "google" {
  project = var.project_id
}

locals {
  prefix = "gcp-cis-hcp-20261013"
  filters = {
    sql       = "protoPayload.methodName=\"cloudsql.instances.update\""
    ownership = "(protoPayload.serviceName=\"cloudresourcemanager.googleapis.com\") AND (ProjectOwnership OR projectOwnerInvitee) OR (protoPayload.serviceData.policyDelta.bindingDeltas.action=\"REMOVE\" AND protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/owner\") OR (protoPayload.serviceData.policyDelta.bindingDeltas.action=\"ADD\" AND protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/owner\")"
    audit     = "protoPayload.methodName=\"SetIamPolicy\" AND protoPayload.serviceData.policyDelta.auditConfigDeltas:*"
    role      = "resource.type=\"iam_role\" AND (protoPayload.methodName=\"google.iam.admin.v1.CreateRole\" OR protoPayload.methodName=\"google.iam.admin.v1.DeleteRole\" OR protoPayload.methodName=\"google.iam.admin.v1.UpdateRole\" OR protoPayload.methodName=\"google.iam.admin.v1.UndeleteRole\")"
    firewall  = "resource.type=\"gce_firewall_rule\" AND (protoPayload.methodName:\"compute.firewalls.patch\" OR protoPayload.methodName:\"compute.firewalls.insert\" OR protoPayload.methodName:\"compute.firewalls.delete\")"
    route     = "resource.type=\"gce_route\" AND (protoPayload.methodName:\"compute.routes.delete\" OR protoPayload.methodName:\"compute.routes.insert\")"
    network   = "resource.type=\"gce_network\" AND (protoPayload.methodName:\"compute.networks.insert\" OR protoPayload.methodName:\"compute.networks.patch\" OR protoPayload.methodName:\"compute.networks.delete\" OR protoPayload.methodName:\"compute.networks.removePeering\" OR protoPayload.methodName:\"compute.networks.addPeering\")"
    storage   = "resource.type=\"gcs_bucket\" AND protoPayload.methodName=\"storage.setIamPermissions\""
  }
}

resource "google_pubsub_topic" "notifications" {
  name = "${local.prefix}-notifications"
}

resource "google_monitoring_notification_channel" "local_test" {
  display_name = "${local.prefix}-channel"
  type         = "pubsub"

  labels = {
    topic = "projects/${var.project_id}/topics/${google_pubsub_topic.notifications.name}"
  }
}

resource "google_logging_metric" "local_test" {
  count  = contains(["metric", "test"], var.phase) ? 1 : 0
  name   = "${local.prefix}-${var.control}"
  filter = local.filters[var.control]

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    unit        = "1"
  }
}

resource "google_monitoring_alert_policy" "local_test" {
  count                 = var.phase == "test" ? 1 : 0
  display_name          = "${local.prefix}-${var.control}-alert"
  combiner              = "OR"
  enabled               = true
  notification_channels = [google_monitoring_notification_channel.local_test.name]

  conditions {
    display_name = "${var.control} changes"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/${google_logging_metric.local_test[0].name}\" AND resource.type=\"${var.control == "storage" ? "gcs_bucket" : "global"}\""
      comparison      = "COMPARISON_GT"
      threshold_value = 0
      duration        = "0s"

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }
}