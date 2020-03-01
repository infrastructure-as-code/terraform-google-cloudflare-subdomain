locals {
  sub_domain_dns_name = "${var.sub_domain}.${var.cloudflare_domain}."
}

resource "google_dns_managed_zone" "sub" {
  name       = var.sub_domain
  dns_name   = local.sub_domain_dns_name
  visibility = "public"
}

resource "cloudflare_record" "sub" {
  count   = 4 #length(google_dns_managed_zone.sub.name_servers)
  zone_id = var.cloudflare_zone_id
  name    = var.sub_domain
  type    = "NS"
  ttl     = var.ttl
  value   = google_dns_managed_zone.sub.name_servers[count.index]
}
