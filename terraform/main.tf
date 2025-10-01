cat > main.tf << 'EOF'
terraform {
  required_version = ">= 1.6.0"
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

# GCS Bucket - 5GB FREE
resource "google_storage_bucket" "data_bucket" {
  name          = "${var.project_id}-data"
  location      = "US"
  force_destroy = true
  
  uniform_bucket_level_access = true
  
  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }
}

# BigQuery Dataset - FREE (10GB)
resource "google_bigquery_dataset" "raw_data" {
  dataset_id  = "raw_data"
  location    = "US"
  description = "Raw Strava data"
}

resource "google_bigquery_dataset" "analytics" {
  dataset_id  = "analytics"
  location    = "US"
  description = "Analytics tables"
}

# BigQuery Table
resource "google_bigquery_table" "strava_activities" {
  dataset_id = google_bigquery_dataset.raw_data.dataset_id
  table_id   = "strava_activities"
  
  time_partitioning {
    type  = "DAY"
    field = "start_date"
  }
  
  clustering = ["type"]
  
  schema = jsonencode([
    {"name": "id", "type": "INTEGER", "mode": "REQUIRED"},
    {"name": "name", "type": "STRING"},
    {"name": "type", "type": "STRING"},
    {"name": "distance", "type": "FLOAT"},
    {"name": "moving_time", "type": "INTEGER"},
    {"name": "elapsed_time", "type": "INTEGER"},
    {"name": "total_elevation_gain", "type": "FLOAT"},
    {"name": "start_date", "type": "TIMESTAMP", "mode": "REQUIRED"},
    {"name": "average_speed", "type": "FLOAT"},
    {"name": "max_speed", "type": "FLOAT"},
    {"name": "average_heartrate", "type": "FLOAT"},
    {"name": "max_heartrate", "type": "INTEGER"},
    {"name": "ingested_at", "type": "TIMESTAMP"},
  ])
}

# Service Account - FREE
resource "google_service_account" "pipeline_sa" {
  account_id   = "strava-pipeline"
  display_name = "Strava Pipeline SA"
}

# Service Account Key
resource "google_service_account_key" "pipeline_key" {
  service_account_id = google_service_account.pipeline_sa.name
}

# IAM - FREE
resource "google_project_iam_member" "pipeline_bq" {
  project = var.project_id
  role    = "roles/bigquery.admin"
  member  = "serviceAccount:${google_service_account.pipeline_sa.email}"
}

resource "google_storage_bucket_iam_member" "pipeline_gcs" {
  bucket = google_storage_bucket.data_bucket.name
  role   = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.pipeline_sa.email}"
}

# Outputs
output "service_account_key" {
  value     = google_service_account_key.pipeline_key.private_key
  sensitive = true
}

output "bucket_name" {
  value = google_storage_bucket.data_bucket.name
}

output "project_id" {
  value = var.project_id
}
EOF