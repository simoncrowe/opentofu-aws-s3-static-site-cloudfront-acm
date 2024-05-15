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

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_cert_arn
    ssl_support_method  = "sni-only"
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

  default_cache_behavior {
    target_origin_id       = "site-redirect-bucket"
    cache_policy_id        = local.caching_disabled_managed_cloudfront_policy_id
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_cert_arn
    ssl_support_method  = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  price_class = var.cloudfront_price_class
}
