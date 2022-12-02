provider "aws" {
  skip_metadata_api_check = true
  region                  = var.bucket_region
}
