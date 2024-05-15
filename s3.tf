resource "aws_s3_bucket" "subdomain" {
  bucket = local.subdomain
}

resource "aws_s3_bucket_website_configuration" "subdomain" {
  bucket = aws_s3_bucket.subdomain.id

  index_document {
    suffix = var.index_key
  }

  error_document {
    key = var.error_key
  }
}

resource "aws_s3_bucket" "root_domain" {
  bucket = var.domain
}

resource "aws_s3_bucket_website_configuration" "root_domain" {
  bucket = aws_s3_bucket.root_domain.id

  redirect_all_requests_to {
    host_name = local.subdomain
    protocol  = "https"
  }
}
