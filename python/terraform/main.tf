terraform {
  required_providers {
    google = {
      version = "4.51.0"
    }
  }
}

provider "google" {
  project     = var.project
  credentials = file(var.sa_credentials)
}


resource "google_project_iam_binding" "storage_sa_role" {
  provider = google
  project  = var.project
  for_each = toset([
    "roles/iam.securityAdmin",
    "roles/storage.admin",
    "roles/secretmanager.admin",
    "roles/pubsub.admin"
  ])
  role = each.key
  members = [
    "serviceAccount:${var.sa_email}"
  ]
}

resource "google_storage_bucket" "bucket" {
  provider                    = google
  project                     = var.project
  name                        = "nl_bucket-tf"
  location                    = "europe-west2"
  storage_class               = "STANDARD"
  force_destroy               = true
  uniform_bucket_level_access = true
}

resource "google_secret_manager_secret" "secret" {
  provider  = google
  project   = var.project
  secret_id = "nl_data-tf"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "secret-version-basic" {
  provider    = google
  secret      = google_secret_manager_secret.secret.id
  secret_data = var.data
  depends_on  = [google_secret_manager_secret.secret]
}

resource "google_pubsub_topic" "topic" {
  name = "function-trigger-tf"
}


resource "google_pubsub_subscription" "subscription" {
  name  = "function-trigger-sub-tf"
  topic = google_pubsub_topic.topic.name
}
