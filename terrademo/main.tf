terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "8.5.0"
    }
  }
}

provider "google" {
  project = "project-a8af3f69-6498-47f8-8da"
  region  = "us-central1"
}


resource "google_storage_bucket" "demo-bucket" {
  name          = "project-a8af3f69-6498-47f8-8da-terra-bucket"
  location      = "US"
  force_destroy = true
  uniform_bucket_level_access = true

  lifecycle_rule {
    condition {
      age = 3
    }
    action {
      type = "Delete"
    }
  }

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}
