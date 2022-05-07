locals {
  bucket_name = "stackguardian-${random_pet.this.id}"
}

resource "random_pet" "this" {
  length = 2
}

module "s3_bucket" {
  source = "github.com/StackGuardian/module-tf-aws-s3-bucket?ref=v2.0.0"

  bucket        = local.bucket_name
  acl           = var.s3_bucket_acl
  force_destroy = var.s3_bucket_force_destroy

  tags = var.s3_bucket_tags

  versioning = var.s3_bucket_versioning

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = var.s3_bucket_block_public_acls
  block_public_policy     = var.s3_bucket_block_public_policy
  ignore_public_acls      = var.s3_bucket_ignore_public_acls
  restrict_public_buckets = var.s3_bucket_restrict_public_buckets
}

resource "null_resource" "remove_and_upload_to_s3" {
  provisioner "local-exec" {
    command = "aws s3 sync ${path.module}/content s3://${module.s3_bucket.s3_bucket_id} --acl public-read --region eu-central-1"
  }
}
