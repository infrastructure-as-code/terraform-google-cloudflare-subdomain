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

resource "null_resource" "wait" {
  # Give the NS record some time to propagate
  provisioner "local-exec" {
    command = "sleep 60"
  }

  depends_on = [
    cloudflare_record.sub,
  ]
}

data "dns_ns_record_set" "sub" {
  host = local.sub_domain_dns_name

  depends_on = [
    null_resource.wait,
  ]
}
