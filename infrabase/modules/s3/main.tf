#Provisioning S3 static hosting bucket.
resource "aws_s3_bucket" "static_hosting" {
  bucket = "${var.project_name}-${var.environment_name}-${var.bucket_name}-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}-bucket"
}

resource "aws_s3_bucket_public_access_block" "static_hosting_public_access" {
  bucket = aws_s3_bucket.static_hosting.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "static_hosting_bucket_ownership" {
  bucket = aws_s3_bucket.static_hosting.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "static_hosting_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.static_hosting_bucket_ownership]
  bucket     = aws_s3_bucket.static_hosting.id
  acl        = "public-read"
}

#Making bucket poliy.
resource "aws_s3_bucket_policy" "static_hosting_bucket_policy" {
  bucket = aws_s3_bucket.static_hosting.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "${aws_s3_bucket.static_hosting.arn}/*"
        }
    ]
}
EOF
}

resource "aws_s3_bucket_website_configuration" "static_hosting_bucket_website_configuration" {
  bucket = aws_s3_bucket.static_hosting.id

  index_document {
    suffix = "index.html"
  }
}

