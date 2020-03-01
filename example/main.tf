################################################################################
# Create both Cloudflare and Google Cloud providers
provider "cloudflare" {
  version   = "~> 2.0"
  api_token = var.cloudflare_api_key
}

provider "google" {
  region  = var.gcp_region
  zone    = var.gcp_zone
  project = var.gcp_project_id
}

################################################################################
# Create the subdomain and a test record
module "subdomain" {
  source             = "./.."
  cloudflare_zone_id = var.cloudflare_zone_id
  cloudflare_domain  = var.cloudflare_domain
  sub_domain         = var.sub_domain
  ttl                = 135
}

resource "google_dns_record_set" "test" {
  name         = "test.${module.subdomain.dns_name}"
  type         = "A"
  ttl          = 135
  managed_zone = var.sub_domain
  rrdatas      = ["127.0.0.1"]
}
