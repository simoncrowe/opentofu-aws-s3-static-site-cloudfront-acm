variable "domain" {
  type        = string
  description = "Domain name for site. This is a root domain e.g. example.com"
}

variable "acm_cert_arn" {
  type = string
  description = "ARN of the public ACM certificate for domain (must be in us-west-1)"
}

variable "index_key" {
  type        = string
  description = "The key of the landing page in the bucket"
  default     = "index.html"
}

variable "error_key" {
  type        = string
  description = "The key of error page in the bucket"
  default     = "error.html"
}

variable "cloudfront_price_class" {
  type        = string
  description = "Price class for CloudFront distribution. One of PriceClass_All, PriceClass_200, PriceClass_100."
  default     = "PriceClass_100"
}
