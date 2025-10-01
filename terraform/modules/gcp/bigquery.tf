# BigQuery Dataset for raw Strava data
resource "google_bigquery_dataset" "strava_raw" {
  dataset_id                 = var.bigquery_dataset_raw
  friendly_name              = "Strava Raw Data"
  description                = "Raw data from Strava API"
  location                   = var.region
  delete_contents_on_destroy = false

  labels = {
    environment = var.environment
    project     = "strava-api"
    managed_by  = "terraform"
  }
}

# BigQuery Dataset for processed Strava data
resource "google_bigquery_dataset" "strava_processed" {
  dataset_id                 = var.bigquery_dataset_processed
  friendly_name              = "Strava Processed Data"
  description                = "Processed and transformed Strava data"
  location                   = var.region
  delete_contents_on_destroy = false

  labels = {
    environment = var.environment
    project     = "strava-api"
    managed_by  = "terraform"
  }
}

# BigQuery Table for activities
resource "google_bigquery_table" "activities" {
  dataset_id          = google_bigquery_dataset.strava_raw.dataset_id
  table_id            = "activities"
  deletion_protection = true

  schema = jsonencode([
    {
      name        = "id"
      type        = "INTEGER"
      mode        = "REQUIRED"
      description = "Activity ID"
    },
    {
      name        = "name"
      type        = "STRING"
      mode        = "NULLABLE"
      description = "Activity name"
    },
    {
      name        = "type"
      type        = "STRING"
      mode        = "NULLABLE"
      description = "Activity type"
    },
    {
      name        = "distance"
      type        = "FLOAT"
      mode        = "NULLABLE"
      description = "Distance in meters"
    },
    {
      name        = "moving_time"
      type        = "INTEGER"
      mode        = "NULLABLE"
      description = "Moving time in seconds"
    },
    {
      name        = "elapsed_time"
      type        = "INTEGER"
      mode        = "NULLABLE"
      description = "Elapsed time in seconds"
    },
    {
      name        = "total_elevation_gain"
      type        = "FLOAT"
      mode        = "NULLABLE"
      description = "Total elevation gain in meters"
    },
    {
      name        = "start_date"
      type        = "TIMESTAMP"
      mode        = "NULLABLE"
      description = "Activity start date"
    },
    {
      name        = "average_speed"
      type        = "FLOAT"
      mode        = "NULLABLE"
      description = "Average speed in m/s"
    },
    {
      name        = "max_speed"
      type        = "FLOAT"
      mode        = "NULLABLE"
      description = "Max speed in m/s"
    },
    {
      name        = "average_heartrate"
      type        = "FLOAT"
      mode        = "NULLABLE"
      description = "Average heart rate"
    },
    {
      name        = "max_heartrate"
      type        = "FLOAT"
      mode        = "NULLABLE"
      description = "Max heart rate"
    },
    {
      name        = "data_fetched_at"
      type        = "TIMESTAMP"
      mode        = "NULLABLE"
      description = "When this data was fetched"
    }
  ])

  labels = {
    environment = var.environment
    project     = "strava-api"
    managed_by  = "terraform"
  }
}
