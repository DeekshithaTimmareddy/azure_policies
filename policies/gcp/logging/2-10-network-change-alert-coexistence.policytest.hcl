policytest {
  targets = [
    "2-5-project-ownership-change-alert.policy.hcl",
    "2-6-audit-config-change-alert.policy.hcl",
    "2-7-custom-role-change-alert.policy.hcl",
    "2-8-firewall-rule-change-alert.policy.hcl",
    "2-9-route-change-alert.policy.hcl",
    "2-10-network-change-alert.policy.hcl",
    "2-11-storage-iam-change-alert.policy.hcl",
    "2-12-sql-config-change-alert.policy.hcl"
  ]
}

resource "google_logging_metric" "ownership_changes" {
  attrs = {
    name   = "coexisting-ownership"
    filter = "protoPayload.serviceName=\"cloudresourcemanager.googleapis.com\" AND ProjectOwnership AND projectOwnerInvitee AND (protoPayload.serviceData.policyDelta.bindingDeltas.action=\"ADD\" AND protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/owner\" OR protoPayload.serviceData.policyDelta.bindingDeltas.action=\"REMOVE\" AND protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/owner\")"
  }
}

resource "google_logging_metric" "audit_config_changes" {
  attrs = {
    name   = "coexisting-audit-config"
    filter = "protoPayload.methodName=\"SetIamPolicy\" AND protoPayload.serviceData.policyDelta.auditConfigDeltas:*"
  }
}

resource "google_logging_metric" "custom_role_changes" {
  attrs = {
    name   = "coexisting-custom-role"
    filter = "resource.type=\"iam_role\" AND (protoPayload.methodName=\"google.iam.admin.v1.CreateRole\" OR protoPayload.methodName=\"google.iam.admin.v1.DeleteRole\" OR protoPayload.methodName=\"google.iam.admin.v1.UpdateRole\" OR protoPayload.methodName=\"google.iam.admin.v1.UndeleteRole\")"
  }
}

resource "google_logging_metric" "firewall_changes" {
  attrs = {
    name   = "coexisting-firewall"
    filter = "resource.type=\"gce_firewall_rule\" AND (protoPayload.methodName:\"compute.firewalls.patch\" OR protoPayload.methodName:\"compute.firewalls.insert\" OR protoPayload.methodName:\"compute.firewalls.delete\")"
  }
}

resource "google_logging_metric" "route_changes" {
  attrs = {
    name   = "coexisting-route"
    filter = "resource.type=\"gce_route\" AND (protoPayload.methodName:\"compute.routes.delete\" OR protoPayload.methodName:\"compute.routes.insert\")"
  }
}

resource "google_logging_metric" "network_changes" {
  attrs = {
    name   = "coexisting-network"
    filter = "resource.type=\"gce_network\" AND (protoPayload.methodName:\"compute.networks.insert\" OR protoPayload.methodName:\"compute.networks.patch\" OR protoPayload.methodName:\"compute.networks.delete\" OR protoPayload.methodName:\"compute.networks.removePeering\" OR protoPayload.methodName:\"compute.networks.addPeering\")"
  }
}

resource "google_logging_metric" "sql_changes" {
  attrs = {
    name   = "coexisting-sql"
    filter = "protoPayload.methodName=\"cloudsql.instances.update\""
  }
}

resource "google_logging_metric" "storage_iam_changes" {
  attrs = {
    name   = "coexisting-storage-iam"
    filter = "resource.type=\"gcs_bucket\" AND protoPayload.methodName=\"storage.setIamPermissions\""
  }
}

resource "google_monitoring_alert_policy" "network_alert" {
  attrs = {
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{ condition_threshold = [{
      filter = "metric.type=\"logging.googleapis.com/user/coexisting-network\" AND resource.type=\"global\""
    }] }]
  }
}

resource "google_monitoring_alert_policy" "sql_alert" {
  attrs = {
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{ condition_threshold = [{
      filter = "metric.type=\"logging.googleapis.com/user/coexisting-sql\" AND resource.type=\"global\""
    }] }]
  }
}

resource "google_monitoring_alert_policy" "ownership_alert" {
  attrs = {
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{ condition_threshold = [{
      filter = "metric.type=\"logging.googleapis.com/user/coexisting-ownership\" AND resource.type=\"global\""
    }] }]
  }
}

resource "google_monitoring_alert_policy" "audit_config_alert" {
  attrs = {
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{ condition_threshold = [{
      filter = "metric.type=\"logging.googleapis.com/user/coexisting-audit-config\" AND resource.type=\"global\""
    }] }]
  }
}

resource "google_monitoring_alert_policy" "custom_role_alert" {
  attrs = {
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{ condition_threshold = [{
      filter = "metric.type=\"logging.googleapis.com/user/coexisting-custom-role\" AND resource.type=\"global\""
    }] }]
  }
}

resource "google_monitoring_alert_policy" "firewall_alert" {
  attrs = {
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{ condition_threshold = [{
      filter = "metric.type=\"logging.googleapis.com/user/coexisting-firewall\" AND resource.type=\"global\""
    }] }]
  }
}

resource "google_monitoring_alert_policy" "route_alert" {
  attrs = {
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{ condition_threshold = [{
      filter = "metric.type=\"logging.googleapis.com/user/coexisting-route\" AND resource.type=\"global\""
    }] }]
  }
}

resource "google_monitoring_alert_policy" "storage_iam_alert" {
  attrs = {
    enabled               = true
    notification_channels = ["projects/my-project/notificationChannels/1234567890"]
    conditions = [{ condition_threshold = [{
      filter = "metric.type=\"logging.googleapis.com/user/coexisting-storage-iam\" AND resource.type=\"global\""
    }] }]
  }
}

resource "google_logging_metric" "unrelated_metric" {
  attrs = {
    name   = "unrelated-compute"
    filter = "resource.type=\"gce_instance\" AND severity>=ERROR"
  }
}

resource "google_monitoring_alert_policy" "unrelated_disabled_alert" {
  attrs = {
    enabled = false
    conditions = [{ condition_threshold = [{
      filter = "metric.type=\"logging.googleapis.com/user/unrelated-compute\" AND resource.type=\"global\""
    }] }]
  }
}