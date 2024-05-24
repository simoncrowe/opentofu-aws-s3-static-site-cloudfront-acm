# Terraform Module: AWS s3 Static Site With cloudfront and ACM

This is a simple OpenTofu/Terraform module for provisioning a static website
using AWS s3, cloudfront.

This module uses s3's website feature. This means that public access to the bucket
needs to be permitted. In the intests of security, access to the bucket is restrited
to clients that send the correct `referer` header. The CloudFront distibution is
configured to include this header when making requests to the s3 website origin.

Unlike many examples, this does not create a bucket and distribution for a `www`
subdomain as well as the main domain. This is because the `www.` convention isn't
as widespread as it once was. The additional complexity and cost isn't justified.


## Example

Below is a minimal working `main.tf`.

```hcl
terraform {
  backend "s3" {
    bucket = "YOUR_TERRAFORM_BACKEND_BUCKET"
    key    = "YOUR_DOMAIN_NAME"
    region = "eu-north-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "site" {
  source = "git::https://github.com/simoncrowe/terraform-aws-s3-static-site-cloudfront.git"

  domain = "YOUR_DOMAIN_NAME"
  acm_cert_arn = "arn:aws:acm:us-east-1:YOUR_ACCOUNT_ID:certificate/YOUR_CERTIFICATE_UUID"
}


output "site_cdn_domain" {
    value = module.site.cloudfront_distribution_domain
}
```


## Manual steps

This module does not include certificate validation or other DNS config. 
You will need to do the following:

* Add an public certificate for your domain using ACM in the `us-west-1` AWS region (Northern Virginia)
* Add CNAME DNS records to your domain to validate the ACM certificate
* Once the CDN exists, add a CNAME DNS record pointing to its domain name (`somerandomchars.cloudfront.net`) to your domain.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.49.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_website_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [random_password.referer_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_cert_arn"></a> [acm\_cert\_arn](#input\_acm\_cert\_arn) | ARN of the public ACM certificate for domain (must be in us-west-1) | `string` | n/a | yes |
| <a name="input_cloudfront_price_class"></a> [cloudfront\_price\_class](#input\_cloudfront\_price\_class) | Price class for CloudFront distribution. One of PriceClass\_All, PriceClass\_200, PriceClass\_100. | `string` | `"PriceClass_100"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Domain name for site. This is a root domain e.g. example.com | `string` | n/a | yes |
| <a name="input_error_key"></a> [error\_key](#input\_error\_key) | The key of error page in the bucket | `string` | `"error.html"` | no |
| <a name="input_index_key"></a> [index\_key](#input\_index\_key) | The key of the landing page in the bucket | `string` | `"index.html"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_distribution_domain"></a> [cloudfront\_distribution\_domain](#output\_cloudfront\_distribution\_domain) | The domain name of your website's CDN. Set up a CNAME DNS record pointing to this domain. |
<!-- END_TF_DOCS -->
