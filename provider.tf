provider "aws" {
  skip_metadata_api_check = true
  region                  = var.bucket_region
  assume_role {
    role_arn     = "arn:aws:iam::871606792318:role/sg-demo-admin-prod"
    session_name = "sg-assumed-role"
    external_id  = "sg-demo-admin-prod"
  }
}
