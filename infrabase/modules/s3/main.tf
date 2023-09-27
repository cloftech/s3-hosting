#Provisioning S3 static hosting bucket.
resource "aws_s3_bucket" "static_hosting" {
  bucket = "${var.project_name}-${var.environment_name}-${var.bucket_name}-bucket"
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

# #Putting objects in the bucket.
# resource "aws_s3_object" "hosting_bucket_files" {
#   bucket = aws_s3_bucket.static_hosting.id

#   for_each = module.template_files.files

#   key          = each.key
#   content_type = each.value.content_type

#   source  = each.value.source_path
#   content = each.value.content

#   etag = each.value.digests.md5
# }

# module "template_files" {
#   source = "hashicorp/dir/template"

#   base_dir = "${path.module}/../../../codebase/my-app/build"
# }
