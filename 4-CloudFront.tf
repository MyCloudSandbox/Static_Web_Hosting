# This file contains the configuration for an AWS CloudFront distribution that serves content from an S3 bucket.
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "Access Identity for S3 bucket"
}

// This resource creates a CloudFront distribution that serves content from the specified S3 bucket.
resource "aws_cloudfront_distribution" "my_distribution" {
  origin {
    domain_name = "${aws_s3_bucket.awswarriors245.bucket_regional_domain_name}"
    origin_id   = "S3-${aws_s3_bucket.awswarriors245.id}"
    
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }
  
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront Distribution for S3 bucket"
  default_root_object = "index.html"

  // All values are defaults from the AWS console.
  default_cache_behavior {
    compress               = true
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    // This needs to match the `origin_id` above.
    target_origin_id       = "S3-${aws_s3_bucket.awswarriors245.id}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  // This is where we set up the viewer certificate for HTTPS.
  aliases = ["${var.root_domain_name}"]

  price_class = "PriceClass_200"


  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
   viewer_certificate {
    acm_certificate_arn            = "arn:aws:acm:us-east-1:704964795421:certificate/57237ae3-b9c5-48d1-9be1-41f35cd3aa10"
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
    cloudfront_default_certificate = false
  }
}

