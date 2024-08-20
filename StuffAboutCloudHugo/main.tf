module "static-website-s3-cloudfront-acm" {
  source  = "joshuamkite/static-website-s3-cloudfront-acm/aws"
  domain_name           = var.domain_name
  deploy_sample_content = true
  providers = {
    aws.us-east-1 = aws.us-east-1
    aws           = aws
  }
}

variable "domain_name" {
  type        = string
  description = "Domain name for website, used for all resources"
}

variable "region" {
  type        = string
  description = "Region for our region-optional resources"
  default     = "ap-southeast-2"
}

variable "tags" {
  type        = map(string)
  description = "Provider default tags, applied to all resources"
  default = {
    managed_by_terraform = true
    terraform_module     = "joshuamkite/static-website-s3-cloudfront-acm/aws"
  }
}

terraform {
  required_version = ">= 1.2.8"
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 4.29.0"
      configuration_aliases = [aws.us-east-1]
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = var.tags
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "us-east-1"
  default_tags {
    tags = var.tags
  }
}

output "cloudfront_domain_name" {
  value = module.static-website-s3-cloudfront-acm.cloudfront_domain_name
}

output "cloudfront_distribution_id" {
  value = module.static-website-s3-cloudfront-acm.cloudfront_distribution_id
}

output "s3_bucket_arn" {
  value = module.static-website-s3-cloudfront-acm.s3_bucket_arn
}

output "s3_bucket_name" {
  value = module.static-website-s3-cloudfront-acm.s3_bucket_name
}

output "acm_certificate_id" {
  value = module.static-website-s3-cloudfront-acm.acm_certificate_id
}

output "website_url" {
  value = "www.${var.domain_name}"
}