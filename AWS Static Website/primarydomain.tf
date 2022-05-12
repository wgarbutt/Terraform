resource "aws_route53_zone" "primary" {
  name = var.domain
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = aws_s3_bucket_website_configuration.domain-static-redirect.website_domain
    zone_id                = aws_s3_bucket.domain-bucket.hosted_zone_id
    evaluate_target_health = true
  }
}

output "Name_Servers" {
  value = aws_route53_zone.primary.name_servers
}


resource "aws_s3_bucket" "domain-bucket" {
  bucket = var.domain
}

resource "aws_s3_bucket_website_configuration" "domain-static-redirect" {
  bucket = aws_s3_bucket.domain-bucket.bucket
  redirect_all_requests_to {
    host_name = var.redirecturl
  }
}