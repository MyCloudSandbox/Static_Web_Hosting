# This Terraform configuration creates an S3 bucket with a public access policy, uploads files from a local directory, and configures the bucket for website hosting.
resource "aws_s3_bucket" "awswarriors245" {
  bucket = "awswarriors245"
  force_destroy = true
}

// This resource sets the bucket policy to allow public read access to objects in the bucket.
resource "aws_s3_bucket_policy" "s3_policy" {
  bucket = aws_s3_bucket.awswarriors245.id
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.awswarriors245.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.awswarriors245.id
  acl    = "private"
}

// This resource configures the S3 bucket to block public access.
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.awswarriors245.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false  
}

locals {
  content_types = {
    ".html" : "text/html",
    ".css" : "text/css",
    ".js" : "text/javascript",
    ".mp4" : "video/mp4",
    ".png" : "image/png"
  }
}

// This resource uploads files from the local directory to the S3 bucket.
resource "aws_s3_object" "file" {
  for_each     = fileset(path.module, "mys3app/**/*.{html,css,js,mp4,png}") #mys3app is the folder that contains the objects to upload to bucket
  bucket       = aws_s3_bucket.awswarriors245.id
  key          = replace(each.value, "/^mys3app//", "")
  source       = each.value
  content_type = lookup(local.content_types, regex("\\.[^.]+$", each.value), null)
  etag         = filemd5(each.value)
}

// This resource configures the S3 bucket for website hosting.
resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.awswarriors245.id
  index_document {
    suffix = "index.html"
  }
}

