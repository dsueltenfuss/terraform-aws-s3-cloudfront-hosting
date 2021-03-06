resource "aws_cloudfront_distribution" "cloudfront" {
  count = local.create_resources ? 1 : 0
  origin {
    connection_attempts = 3
    connection_timeout  = 10
    domain_name         = data.aws_s3_bucket.s3_bucket.website_endpoint
    origin_id           = data.aws_s3_bucket.s3_bucket.website_endpoint

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols = [
        "TLSv1.2",
      ]
    }

  }
  enabled         = true
  is_ipv6_enabled = true

  aliases = [var.website_address]

  default_cache_behavior {
    cache_policy_id  = aws_cloudfront_cache_policy.cloudfront_cache_policy[0].id
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = data.aws_s3_bucket.s3_bucket.website_endpoint

    viewer_protocol_policy = "allow-all"
    compress               = true
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.certificate[0].arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
}

resource "aws_cloudfront_cache_policy" "cloudfront_cache_policy" {
  count   = local.create_resources ? 1 : 0
  name    = join("", [replace(var.website_address, ".", "-"), "-CachingOptimized"])
  min_ttl = 1
  comment = "Default policy when CF compression is enabled"
  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "none"
    }
    cookies_config {
      cookie_behavior = "none"
    }
  }

}