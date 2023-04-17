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


resource "google_project_iam_binding" "sa_role" {
  provider = google
  project  = var.project
  for_each = toset([
    "roles/storage.admin",
    "roles/secretmanager.admin",
    "roles/pubsub.admin",
    "roles/bigquery.admin"
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

  depends_on = [
    google_project_iam_binding.sa_role
  ]
}

resource "google_secret_manager_secret" "secret" {
  provider  = google
  project   = var.project
  secret_id = "nl_data-tf"
  replication {
    automatic = true
  }
  depends_on = [
    google_project_iam_binding.sa_role
  ]
}

resource "google_secret_manager_secret_version" "secret-version-basic" {
  provider    = google
  secret      = google_secret_manager_secret.secret.id
  secret_data = var.data
  depends_on  = [google_project_iam_binding.sa_role, google_secret_manager_secret.secret]
}

resource "google_pubsub_topic" "topic" {
  name = "function-trigger-tf"
  depends_on = [
    google_project_iam_binding.sa_role
  ]
}


resource "google_pubsub_subscription" "subscription" {
  name  = "function-trigger-sub-tf"
  topic = google_pubsub_topic.topic.name
  depends_on = [
    google_project_iam_binding.sa_role, google_pubsub_topic.topic
  ]
}

resource "google_bigquery_dataset" "dataset" {
  for_each = toset([
    "bikeshare_import",
    "bikeshare_stg",
    "bikeshare"
  ])
  dataset_id = each.key
  location   = "europe-west2"
  access {
    role          = "EDITOR"
    user_by_email = var.sa_email
  }
  access {
    role          = "OWNER"
    user_by_email = var.forecast_email
  }
  access {
    role          = "EDITOR"
    user_by_email = var.sky_email
  }

  access {
    role          = "READER"
    special_group = "projectReaders"
  }
  depends_on = [
    google_project_iam_binding.sa_role
  ]
}
