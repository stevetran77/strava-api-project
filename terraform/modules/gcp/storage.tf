# GCS Bucket for storing raw Strava data
resource "google_storage_bucket" "strava_data" {
  name          = var.bucket_name
  location      = var.region
  force_destroy = false

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = 90
    }
    action {
      type = "Delete"
    }
  }

  labels = {
    environment = var.environment
    project     = "strava-api"
    managed_by  = "terraform"
  }
}
