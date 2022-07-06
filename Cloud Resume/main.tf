## Set up bucket named "site" ##
resource "aws_s3_bucket" "site" {
  bucket = var.site_domain
}

## Set the newly created bucket website configuration ##
resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.site.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

## Set bucket ACL to public read ##
resource "aws_s3_bucket_acl" "site" {
  bucket = aws_s3_bucket.site.id

  acl = "public-read"
}

## Set bucket access policy to public allow get all ##
resource "aws_s3_bucket_policy" "site" {
  bucket = aws_s3_bucket.site.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = [
          aws_s3_bucket.site.arn,
          "${aws_s3_bucket.site.arn}/*",
        ]
      }
    ]
  })
}

## create a bucket to redirect www ##
resource "aws_s3_bucket" "www" {
  bucket = "www.${var.site_domain}"
}

## set ACL to private, bucket will store nothing ##
resource "aws_s3_bucket_acl" "www" {
  bucket = aws_s3_bucket.www.id

  acl = "private"
}

## set bucket to redirect all www requests to actual webpage ##
resource "aws_s3_bucket_website_configuration" "www" {
  bucket = aws_s3_bucket.www.id

  redirect_all_requests_to {
    host_name = var.site_domain
  }
}

## Setup domain on Cloudflare ##
data "cloudflare_zones" "domain" {
  filter {
    name = var.site_domain
  }
}

## setup cname record to point to AWS bucket static website ##
resource "cloudflare_record" "site_cname" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  name    = var.site_domain
  value   = aws_s3_bucket_website_configuration.www.website_endpoint
  type    = "CNAME"
  ttl     = 1
  proxied = true
}

## setup cname to point www to main website ##
resource "cloudflare_record" "www" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  name    = "www"
  value   = var.site_domain
  type    = "CNAME"
  ttl     = 1
  proxied = true
}

## set to always use HTTPS ##
resource "cloudflare_page_rule" "https" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  target  = "*.${var.site_domain}/*"
  actions {
    always_use_https = true
  }
}
