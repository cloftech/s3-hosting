# Data for AWS current account
data "aws_caller_identity" "current" {}

# Data for AWS current region
data "aws_region" "current" {}