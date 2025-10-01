output "bucket_name" {
  description = "Name of the created GCS bucket"
  value       = module.gcp.bucket_name
}

output "bucket_url" {
  description = "URL of the created GCS bucket"
  value       = module.gcp.bucket_url
}

output "bigquery_dataset_raw_id" {
  description = "ID of the raw BigQuery dataset"
  value       = module.gcp.bigquery_dataset_raw_id
}

output "bigquery_dataset_processed_id" {
  description = "ID of the processed BigQuery dataset"
  value       = module.gcp.bigquery_dataset_processed_id
}

output "bigquery_activities_table" {
  description = "Full ID of the activities BigQuery table"
  value       = module.gcp.bigquery_activities_table
}

output "project_id" {
  description = "GCP Project ID"
  value       = module.gcp.project_id
}

output "region" {
  description = "GCP Region"
  value       = module.gcp.region
}
