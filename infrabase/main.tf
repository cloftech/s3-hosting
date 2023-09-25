module "s3" {
  source           = "./modules/s3"
  project_name     = var.project_name
  environment_name = var.environment_name
  # bucket_name      = var.bucket_name
}