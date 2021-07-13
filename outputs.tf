output "s3_bucket_region" {
  description = "The AWS region this bucket resides in"
  value       = module.s3_bucket.s3_bucket_region
}

output "website_domain" {
  description = "The domain of the website endpoint"
  value       = module.s3_bucket.s3_bucket_website_domain
}