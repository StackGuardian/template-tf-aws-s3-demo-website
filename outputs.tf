output "s3_bucket_region" {
  description = "The AWS region this bucket resides in"
  value       = module.s3_bucket.s3_bucket_region
}

output "this_s3_bucket_website_endpoint" {
  description = "The sample website endpoint"
  value       = format("%s%s", "https://", module.s3_bucket.s3_bucket_website_endpoint)
}