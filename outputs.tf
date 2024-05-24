output "cloudfront_distribution_domain" {
  description = "The domain name of your website's CDN. Set up a CNAME DNS record pointing to this domain."
  value = aws_cloudfront_distribution.this.domain_name
}
