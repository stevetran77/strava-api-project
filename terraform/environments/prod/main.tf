module "gcp" {
  source = "../../modules/gcp"

  project_id                  = var.project_id
  region                      = var.region
  environment                 = "prod"
  bucket_name                 = var.bucket_name
  bigquery_dataset_raw        = "strava_raw"
  bigquery_dataset_processed  = "strava_processed"
}
