terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 5.0"
      configuration_aliases = [aws.us-west-1]
    }
  }
}

resource "random_password" "referer_secret" {
  length = 63
}
