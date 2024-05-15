resource "aws_cloudfront_distribution" "subdomain" {
  enabled = true
  aliases = [local.subdomain]

  origin {
    origin_id   = "site-files-bucket"
    domain_name = aws_s3_bucket_website_configuration.root_domain.website_endpoint

    custom_header {
      name  = "referer"
      value = random_password.referer_secret.result
    }
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.1", "TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"
    target_origin_id       = "site-files-bucket"
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.domain.arn
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  price_class = var.cloudfront_price_class
}

resource "aws_cloudfront_distribution" "root_domain" {
  enabled = true
  aliases = [var.domain]

  origin {
    origin_id   = "site-redirect-bucket"
    domain_name = aws_s3_bucket_website_configuration.root_domain.website_endpoint

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.1", "TLSv1.2"]
    }
  }

  # AWS Managed Caching Policy (CachingDisabled)
  default_cache_behavior {
    # Using the CachingDisabled managed policy ID:
    cache_policy_id        = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = []
    target_origin_id       = "site-redirect-bucket"
    viewer_protocol_policy = "redirect-to-https"
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.domain.arn
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  price_class = var.cloudfront_price_class
}
