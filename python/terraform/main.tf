terraform {
  required_providers {
    google = {
      version = "4.51.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project
}

resource "google_storage_bucket" "my_bucket" {
  name                        = "norberts-garbage-tf"
  location                    = "europe-west2"
  storage_class               = "STANDARD"
  force_destroy               = true
  uniform_bucket_level_access = true
}