resource "aws_cloudfront_distribution" "this" {
  enabled = true
  aliases = [var.domain]
  comment = "CDN for website files"

  origin {
    origin_id   = "site-files-bucket"
    domain_name = aws_s3_bucket_website_configuration.this.website_endpoint

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

    cache_policy_id = local.optimised_uncompressed_managed_cloudfront_policy_id
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
