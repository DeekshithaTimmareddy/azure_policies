resource_policy "azurerm_security_center_subscription_pricing" "8_1_4_1" {
  filter = core::try(attrs.resource_type, null) == "Containers"

  locals {
    tier_raw = core::try(attrs.tier, null)
    tier     = local.tier_raw == null ? "" : local.tier_raw

    extensions = core::try([for e in attrs.extension : e], [])

    required_extension_names = [
      "ContainerRegistriesVulnerabilityAssessments",
      "AgentlessDiscoveryForKubernetes",
      "AgentlessVmScanning",
      "ContainerSensor",
    ]

    missing_extensions = [
      for name in local.required_extension_names : name
      if core::length([for e in local.extensions : e if core::try(e.name, "") == name]) == 0
    ]

    all_extensions_present = core::length(local.missing_extensions) == 0
  }

  enforcement_level = "advisory"

  enforce {
    condition     = local.tier == "Standard" && local.all_extensions_present
    error_message = "Microsoft Defender for Containers must be On with full monitoring coverage: azurerm_security_center_subscription_pricing for resource_type=Containers must set tier = \"Standard\" and define an extension block for each of ContainerRegistriesVulnerabilityAssessments, AgentlessDiscoveryForKubernetes, AgentlessVmScanning, and ContainerSensor."
  }
}
