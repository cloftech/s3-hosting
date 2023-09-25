terraform {
  backend "s3" {
    bucket = "todo-app-state-bucket"
    region = "us-east-1"
    key    = "dev"
  }
}