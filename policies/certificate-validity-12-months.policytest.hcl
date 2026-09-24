policytest {
  targets = ["certificate-validity-12-months.policy.hcl"]
}

resource "azurerm_key_vault_certificate" "validity_12_boundary_pass" {
  attrs = {
    name         = "cert-validity-12"
    key_vault_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv"
    certificate_policy = [{
      issuer_parameters = [{ name = "Self" }]
      key_properties = [{
        exportable = true
        key_type   = "RSA"
        reuse_key  = false
      }]
      secret_properties = [{ content_type = "application/x-pkcs12" }]
      x509_certificate_properties = [{
        key_usage          = ["digitalSignature"]
        subject            = "CN=twelve.example.com"
        validity_in_months = 12
      }]
    }]
  }
}

resource "azurerm_key_vault_certificate" "validity_6_pass" {
  attrs = {
    name         = "cert-validity-6"
    key_vault_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv"
    certificate_policy = [{
      issuer_parameters = [{ name = "Self" }]
      key_properties = [{
        exportable = true
        key_type   = "RSA"
        reuse_key  = false
      }]
      secret_properties = [{ content_type = "application/x-pkcs12" }]
      x509_certificate_properties = [{
        key_usage          = ["digitalSignature"]
        subject            = "CN=six.example.com"
        validity_in_months = 6
      }]
    }]
  }
}

resource "azurerm_key_vault_certificate" "validity_1_pass" {
  attrs = {
    name         = "cert-validity-1"
    key_vault_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv"
    certificate_policy = [{
      issuer_parameters = [{ name = "Self" }]
      key_properties = [{
        exportable = true
        key_type   = "RSA"
        reuse_key  = false
      }]
      secret_properties = [{ content_type = "application/x-pkcs12" }]
      x509_certificate_properties = [{
        key_usage          = ["digitalSignature"]
        subject            = "CN=one.example.com"
        validity_in_months = 1
      }]
    }]
  }
}

resource "azurerm_key_vault_certificate" "no_certificate_policy_pass" {
  attrs = {
    name         = "cert-imported-no-policy"
    key_vault_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv"
    certificate = [{
      contents = "base64-encoded-pfx-placeholder"
    }]
  }
}

resource "azurerm_key_vault_certificate" "validity_13_boundary_fail" {
  expect_failure = true
  attrs = {
    name         = "cert-validity-13"
    key_vault_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv"
    certificate_policy = [{
      issuer_parameters = [{ name = "Self" }]
      key_properties = [{
        exportable = true
        key_type   = "RSA"
        reuse_key  = false
      }]
      secret_properties = [{ content_type = "application/x-pkcs12" }]
      x509_certificate_properties = [{
        key_usage          = ["digitalSignature"]
        subject            = "CN=thirteen.example.com"
        validity_in_months = 13
      }]
    }]
  }
}

resource "azurerm_key_vault_certificate" "validity_24_fail" {
  expect_failure = true
  attrs = {
    name         = "cert-validity-24"
    key_vault_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv"
    certificate_policy = [{
      issuer_parameters = [{ name = "Self" }]
      key_properties = [{
        exportable = true
        key_type   = "RSA"
        reuse_key  = false
      }]
      secret_properties = [{ content_type = "application/x-pkcs12" }]
      x509_certificate_properties = [{
        key_usage          = ["digitalSignature"]
        subject            = "CN=twentyfour.example.com"
        validity_in_months = 24
      }]
    }]
  }
}

resource "azurerm_key_vault_certificate" "validity_60_fail" {
  expect_failure = true
  attrs = {
    name         = "cert-validity-60"
    key_vault_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv"
    certificate_policy = [{
      issuer_parameters = [{ name = "Self" }]
      key_properties = [{
        exportable = true
        key_type   = "RSA"
        reuse_key  = false
      }]
      secret_properties = [{ content_type = "application/x-pkcs12" }]
      x509_certificate_properties = [{
        key_usage          = ["digitalSignature"]
        subject            = "CN=sixty.example.com"
        validity_in_months = 60
      }]
    }]
  }
}
