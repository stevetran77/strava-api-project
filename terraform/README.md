# Strava API - Terraform Infrastructure

This Terraform configuration creates FREE GCP resources for your Strava API project:

## Resources Created

✅ **Google Cloud Storage (GCS) Bucket**
- Store raw Strava API data
- 5 GB free storage per month
- 90-day lifecycle rule for automatic cleanup

✅ **BigQuery Datasets & Tables**
- `strava_raw`: Raw data from Strava API
- `strava_processed`: Processed and transformed data
- `activities` table with comprehensive schema
- 10 GB free storage + 1 TB free queries per month

✅ **No Service Account Required**
- Uses your existing Strava credentials from `strava-credentials.txt`
- GCP access via your gcloud authentication

## Prerequisites

1. **Install Terraform**: [Download here](https://www.terraform.io/downloads)
2. **GCP Project**: Create a free GCP project at [console.cloud.google.com](https://console.cloud.google.com)
3. **Authenticate with GCP**:
   ```bash
   gcloud auth application-default login
   ```

## Setup Instructions

### 1. Configure Variables

Edit `terraform/environments/prod/terraform.tfvars`:

```hcl
# Your GCP Project ID (find it in GCP Console)
project_id = "your-actual-project-id"

# Region (use us-central1 for free tier)
region = "us-central1"

# Bucket name (must be globally unique)
bucket_name = "your-unique-bucket-name"
```

### 2. Deploy Infrastructure

```bash
cd terraform/environments/prod

# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Deploy (type 'yes' when prompted)
terraform apply
```

### 3. Verify Deployment

After successful deployment, you'll see outputs:

```
Outputs:

bucket_name = "your-bucket-name"
bucket_url = "gs://your-bucket-name"
bigquery_dataset_raw_id = "strava_raw"
bigquery_dataset_processed_id = "strava_processed"
bigquery_activities_table = "your-project.strava_raw.activities"
project_id = "your-project-id"
region = "us-central1"
```

## Usage

### Store Data in GCS

```python
from google.cloud import storage

client = storage.Client()
bucket = client.bucket('your-bucket-name')
blob = bucket.blob('activities/2024-01-01.json')
blob.upload_from_string(json.dumps(data))
```

### Load Data to BigQuery

```python
from google.cloud import bigquery

client = bigquery.Client()
table_id = "your-project.strava_raw.activities"

client.load_table_from_json(activities, table_id)
```

## Cost Information

All resources are configured to stay within GCP's **FREE tier**:

- **GCS**: 5 GB storage/month
- **BigQuery**: 10 GB storage + 1 TB queries/month
- **No charges** as long as you stay within free tier limits

## Managing Infrastructure

```bash
# View current state
terraform show

# Update infrastructure
terraform apply

# Destroy all resources (WARNING: deletes data)
terraform destroy
```

## Directory Structure

```
terraform/
├── modules/gcp/          # Reusable GCP module
│   ├── provider.tf       # Provider configuration
│   ├── variables.tf      # Input variables
│   ├── storage.tf        # GCS bucket
│   ├── bigquery.tf       # BigQuery datasets & tables
│   ├── iam.tf            # IAM configuration
│   └── outputs.tf        # Output values
└── environments/
    └── prod/             # Production environment
        ├── main.tf       # Main configuration
        ├── variables.tf  # Environment variables
        ├── terraform.tfvars  # Variable values
        └── outputs.tf    # Environment outputs
```

## Troubleshooting

### Authentication Issues
```bash
# Re-authenticate with GCP
gcloud auth application-default login
```

### Bucket Name Already Exists
GCS bucket names must be globally unique. Change `bucket_name` in `terraform.tfvars` to something unique.

### API Not Enabled
If you get API errors, enable required APIs:
```bash
gcloud services enable storage.googleapis.com
gcloud services enable bigquery.googleapis.com
```

## Next Steps

1. Update your Python application to use these GCP resources
2. Load Strava data from API into BigQuery
3. Build analytics dashboards in Looker Studio (free)
4. Set up scheduled data syncs with Cloud Scheduler (free tier available)
