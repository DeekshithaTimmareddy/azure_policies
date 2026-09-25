policytest {
  targets = ["defender-containers-on.policy.hcl"]
}

resource "azurerm_security_center_subscription_pricing" "containers_standard_all_extensions" {
  attrs = {
    resource_type = "Containers"
    tier          = "Standard"
    extension = [
      { name = "ContainerRegistriesVulnerabilityAssessments" },
      { name = "AgentlessDiscoveryForKubernetes" },
      { name = "AgentlessVmScanning" },
      { name = "ContainerSensor" },
    ]
  }
}

resource "azurerm_security_center_subscription_pricing" "containers_free" {
  expect_failure = true
  attrs = {
    resource_type = "Containers"
    tier          = "Free"
    extension = [
      { name = "ContainerRegistriesVulnerabilityAssessments" },
      { name = "AgentlessDiscoveryForKubernetes" },
      { name = "AgentlessVmScanning" },
      { name = "ContainerSensor" },
    ]
  }
}

resource "azurerm_security_center_subscription_pricing" "containers_tier_absent" {
  expect_failure = true
  attrs = {
    resource_type = "Containers"
    extension = [
      { name = "ContainerRegistriesVulnerabilityAssessments" },
      { name = "AgentlessDiscoveryForKubernetes" },
      { name = "AgentlessVmScanning" },
      { name = "ContainerSensor" },
    ]
  }
}

resource "azurerm_security_center_subscription_pricing" "containers_tier_empty" {
  expect_failure = true
  attrs = {
    resource_type = "Containers"
    tier          = ""
    extension = [
      { name = "ContainerRegistriesVulnerabilityAssessments" },
      { name = "AgentlessDiscoveryForKubernetes" },
      { name = "AgentlessVmScanning" },
      { name = "ContainerSensor" },
    ]
  }
}

resource "azurerm_security_center_subscription_pricing" "containers_standard_no_extensions" {
  expect_failure = true
  attrs = {
    resource_type = "Containers"
    tier          = "Standard"
  }
}

resource "azurerm_security_center_subscription_pricing" "containers_standard_partial_extensions" {
  expect_failure = true
  attrs = {
    resource_type = "Containers"
    tier          = "Standard"
    extension = [
      { name = "ContainerRegistriesVulnerabilityAssessments" },
      { name = "AgentlessDiscoveryForKubernetes" },
    ]
  }
}

resource "azurerm_security_center_subscription_pricing" "vms_free" {
  attrs = {
    resource_type = "VirtualMachines"
    tier          = "Free"
  }
}

resource "azurerm_security_center_subscription_pricing" "storage_standard" {
  attrs = {
    resource_type = "StorageAccounts"
    tier          = "Standard"
  }
}

resource "azurerm_security_center_subscription_pricing" "type_absent_free" {
  attrs = {
    tier = "Free"
  }
}
