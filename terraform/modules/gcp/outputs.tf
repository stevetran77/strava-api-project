output "bucket_name" {
  description = "Name of the created GCS bucket"
  value       = google_storage_bucket.strava_data.name
}

output "bucket_url" {
  description = "URL of the created GCS bucket"
  value       = google_storage_bucket.strava_data.url
}

output "bigquery_dataset_raw_id" {
  description = "ID of the raw BigQuery dataset"
  value       = google_bigquery_dataset.strava_raw.dataset_id
}

output "bigquery_dataset_processed_id" {
  description = "ID of the processed BigQuery dataset"
  value       = google_bigquery_dataset.strava_processed.dataset_id
}

output "bigquery_activities_table" {
  description = "Full ID of the activities BigQuery table"
  value       = "${var.project_id}.${google_bigquery_dataset.strava_raw.dataset_id}.${google_bigquery_table.activities.table_id}"
}

output "project_id" {
  description = "GCP Project ID"
  value       = var.project_id
}

output "region" {
  description = "GCP Region"
  value       = var.region
}
