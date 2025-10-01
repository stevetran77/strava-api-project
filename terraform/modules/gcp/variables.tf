variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "bucket_name" {
  description = "Name of the GCS bucket for storing Strava data"
  type        = string
}

variable "bigquery_dataset_raw" {
  description = "BigQuery dataset name for raw data"
  type        = string
  default     = "strava_raw"
}

variable "bigquery_dataset_processed" {
  description = "BigQuery dataset name for processed data"
  type        = string
  default     = "strava_processed"
}
