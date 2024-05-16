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

resource "aws_s3_bucket_public_access_block" "subdomain" {
  bucket = aws_s3_bucket.subdomain.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

data "aws_iam_policy_document" "subdomain" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.subdomain.id}",
      "arn:aws:s3:::${aws_s3_bucket.subdomain.id}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "subdomain" {
  bucket = aws_s3_bucket.subdomain.id
  policy = data.aws_iam_policy_document.subdomain.json
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
