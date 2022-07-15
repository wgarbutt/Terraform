terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.0.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "2.19.2"
    }
  }
}

provider "aws" {
  region     = "ap-southeast-2"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "cloudflare" {
  api_token = var.cloudflare_api
}