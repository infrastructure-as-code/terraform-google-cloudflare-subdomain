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
resource "random_id" "suffix" {
  byte_length = 2
}

locals {
  sub_domain = "${var.sub_domain}-${random_id.suffix.dec}"
}

module "subdomain" {
  source             = "./.."
  cloudflare_zone_id = var.cloudflare_zone_id
  cloudflare_domain  = var.cloudflare_domain
  sub_domain         = local.sub_domain
  ttl                = 135
}

locals {
  test_hostname = "test.${module.subdomain.dns_name}"
}

resource "google_dns_record_set" "test" {
  name         = local.test_hostname
  type         = "A"
  ttl          = 135
  managed_zone = local.sub_domain
  rrdatas      = ["127.0.0.2"]

  depends_on = [
    module.subdomain,
  ]
}

resource "null_resource" "wait" {
  # Give the NS record some time to propagate
  provisioner "local-exec" {
    command = "sleep 60"
  }

  depends_on = [
    google_dns_record_set.test,
  ]
}

data "dns_a_record_set" "test" {
  host = local.test_hostname

  depends_on = [
    null_resource.wait,
  ]
}

output "test_host_ip" {
  value = data.dns_a_record_set.test.addrs
}
