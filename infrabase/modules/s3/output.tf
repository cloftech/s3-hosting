output "website_url" {
  description = "URL of the website"
  value       = aws_s3_bucket_website_configuration.static_hosting_bucket_website_configuration.website_endpoint
}

output "bucket" {
  description = "Bucket name"
  value       = aws_s3_bucket.static_hosting.bucket
}