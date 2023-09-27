output "website_url" {
  description = "URL of the website"
  value       = module.s3.website_url
}

output "bucket" {
  description = "Bucket name"
  value       = module.s3.bucket
}
