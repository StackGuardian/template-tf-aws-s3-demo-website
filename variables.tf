variable "shop_name" {
  type    = string
  default = "StackGuardian"
}

variable "bucket_region" {
  type    = string
  default = "eu-central-1"
}

variable "s3_bucket_acl" {
  type    = string
  default = "public-read"
}

variable "s3_bucket_force_destroy" {
  type    = bool
  default = true
}

variable "s3_bucket_block_public_acls" {
  type    = bool
  default = false
}

variable "s3_bucket_block_public_policy" {
  type    = bool
  default = false
}

variable "s3_bucket_ignore_public_acls" {
  type    = bool
  default = false
}

variable "s3_bucket_restrict_public_buckets" {
  type    = bool
  default = false
}

variable "s3_bucket_tags" {
  type = map(string)
  default = {
    Owner = "stackguardian"
  }
}

variable "s3_bucket_versioning" {
  type = map(string)
  default = {
    enabled    = true
    mfa_delete = false
  }
}

variable role_to_be_assumed {
  type        = string
  default     = "arn:aws:iam::871606792318:role/sg-demo-admin-prod"
  description = "role to be assumed"
}
