resource "aws_acm_certificate" "domain" {
  provider = aws.us-west-1

  domain_name       = var.domain
  validation_method = "DNS"
}
