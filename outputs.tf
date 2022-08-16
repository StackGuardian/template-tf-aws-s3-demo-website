output "sample_website_url" {
  description = "The sample website url"
  value       = format("%s%s", "http://", module.s3_bucket.s3_bucket_website_endpoint)
}
