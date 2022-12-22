provider "aws" {
  skip_metadata_api_check = true
  region                  = var.bucket_region
  assume_role {
    role_arn     = var.role_to_be_assumed
    session_name = "sg-assumed-role"
    external_id  = "sg-demo-admin-prod"
  }
}
