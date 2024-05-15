resource "aws_acm_certificate" "domain" {
  domain_name       = var.domain
  validation_method = "DNS"
}
