provider "aws" {
  skip_metadata_api_check = true
  region                  = var.bucket_region
  # assume_role {
  #   role_arn = "arn:aws:iam::${account_id}:role/${assume_role}"
  # }
}

terraform {
  required_version = ">= 0.12.6, <= 1.1.7"

  required_providers {
    aws    = ">= 3.0, < 4.0"
    random = "~> 3"
  }
}