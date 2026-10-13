# Copyright IBM Corp. 2026

policytest {
  targets = ["1-10-kms-not-public.policy.hcl"]
}

resource "google_kms_crypto_key_iam_member" "pass_member_user" {
  attrs = {
    crypto_key_id = "projects/p/locations/global/keyRings/kr/cryptoKeys/k1"
    role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
    member        = "user:alice@example.com"
  }
}

resource "google_kms_crypto_key_iam_member" "pass_member_sa" {
  attrs = {
    crypto_key_id = "projects/p/locations/global/keyRings/kr/cryptoKeys/k2"
    role          = "roles/cloudkms.cryptoKeyDecrypter"
    member        = "serviceAccount:sa@p.iam.gserviceaccount.com"
  }
}

resource "google_kms_crypto_key_iam_member" "fail_member_allusers" {
  expect_failure = true
  attrs = {
    crypto_key_id = "projects/p/locations/global/keyRings/kr/cryptoKeys/k3"
    role          = "roles/cloudkms.cryptoKeyDecrypter"
    member        = "allUsers"
  }
}

resource "google_kms_crypto_key_iam_member" "fail_member_allauth" {
  expect_failure = true
  attrs = {
    crypto_key_id = "projects/p/locations/global/keyRings/kr/cryptoKeys/k4"
    role          = "roles/cloudkms.cryptoKeyEncrypter"
    member        = "allAuthenticatedUsers"
  }
}

resource "google_kms_crypto_key_iam_binding" "pass_binding_private" {
  attrs = {
    crypto_key_id = "projects/p/locations/global/keyRings/kr/cryptoKeys/k5"
    role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
    members       = ["user:alice@example.com", "group:ops@example.com"]
  }
}

resource "google_kms_crypto_key_iam_binding" "pass_binding_empty" {
  attrs = {
    crypto_key_id = "projects/p/locations/global/keyRings/kr/cryptoKeys/k6"
    role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
    members       = []
  }
}

resource "google_kms_crypto_key_iam_binding" "fail_binding_allusers" {
  expect_failure = true
  attrs = {
    crypto_key_id = "projects/p/locations/global/keyRings/kr/cryptoKeys/k7"
    role          = "roles/cloudkms.cryptoKeyDecrypter"
    members       = ["allUsers"]
  }
}

resource "google_kms_crypto_key_iam_binding" "fail_binding_mixed_allauth" {
  expect_failure = true
  attrs = {
    crypto_key_id = "projects/p/locations/global/keyRings/kr/cryptoKeys/k8"
    role          = "roles/cloudkms.cryptoKeyDecrypter"
    members       = ["user:alice@example.com", "allAuthenticatedUsers", "group:ops@example.com"]
  }
}

resource "google_kms_crypto_key_iam_policy" "pass_policy_private" {
  attrs = {
    crypto_key_id = "projects/p/locations/global/keyRings/kr/cryptoKeys/k9"
    policy_data   = "{\"bindings\":[{\"role\":\"roles/cloudkms.cryptoKeyEncrypterDecrypter\",\"members\":[\"user:alice@example.com\"]}]}"
  }
}

resource "google_kms_crypto_key_iam_policy" "pass_policy_condition_title_allusers" {
  attrs = {
    crypto_key_id = "projects/p/locations/global/keyRings/kr/cryptoKeys/k16"
    policy_data   = "{\"bindings\":[{\"role\":\"roles/cloudkms.cryptoKeyEncrypterDecrypter\",\"members\":[\"user:alice@example.com\"],\"condition\":{\"title\":\"allUsers\",\"expression\":\"true\"}}]}"
  }
}

resource "google_kms_crypto_key_iam_policy" "pass_policy_empty" {
  attrs = {
    crypto_key_id = "projects/p/locations/global/keyRings/kr/cryptoKeys/k10"
    policy_data   = "{}"
  }
}

resource "google_kms_crypto_key_iam_policy" "fail_policy_allusers" {
  expect_failure = true
  attrs = {
    crypto_key_id = "projects/p/locations/global/keyRings/kr/cryptoKeys/k11"
    policy_data   = "{\"bindings\":[{\"role\":\"roles/cloudkms.cryptoKeyDecrypter\",\"members\":[\"allUsers\"]}]}"
  }
}

resource "google_kms_crypto_key_iam_policy" "fail_policy_second_binding_allauth" {
  expect_failure = true
  attrs = {
    crypto_key_id = "projects/p/locations/global/keyRings/kr/cryptoKeys/k12"
    policy_data   = "{\"bindings\":[{\"role\":\"roles/cloudkms.cryptoKeyEncrypterDecrypter\",\"members\":[\"user:alice@example.com\"]},{\"role\":\"roles/cloudkms.cryptoKeyDecrypter\",\"members\":[\"group:ops@example.com\",\"allAuthenticatedUsers\"]}]}"
  }
}

resource "google_kms_crypto_key_iam_member" "pass_member_group_email_contains_allusers" {
  attrs = {
    crypto_key_id = "projects/p/locations/global/keyRings/kr/cryptoKeys/k13"
    role          = "roles/cloudkms.cryptoKeyDecrypter"
    member        = "group:allUsers-team@example.com"
  }
}

resource "google_kms_crypto_key_iam_binding" "pass_binding_group_email_contains_allauth" {
  attrs = {
    crypto_key_id = "projects/p/locations/global/keyRings/kr/cryptoKeys/k14"
    role          = "roles/cloudkms.cryptoKeyDecrypter"
    members       = ["group:allAuthenticatedUsers-ops@example.com", "user:allusers@example.com"]
  }
}

resource "google_kms_crypto_key_iam_policy" "pass_policy_group_email_contains_allusers" {
  attrs = {
    crypto_key_id = "projects/p/locations/global/keyRings/kr/cryptoKeys/k15"
    policy_data   = "{\"bindings\":[{\"role\":\"roles/cloudkms.cryptoKeyDecrypter\",\"members\":[\"group:allUsers@example.com\",\"user:allAuthenticatedUsers@example.com\"]}]}"
  }
}
