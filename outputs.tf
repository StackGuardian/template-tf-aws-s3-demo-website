output "id" {
  description = "Name of the Bucket"
  value       = aws_s3_bucket.s3_bucket.id
}
output "website_domain" {
  description = "Domain of the website endpoint."
  value       = aws_s3_bucket_website_configuration.s3_bucket.website_domain
}

output "website_endpoint" {
  description = "The sample website URL"
  value       = "http://${aws_s3_bucket_website_configuration.s3_bucket.website_endpoint}"
}

