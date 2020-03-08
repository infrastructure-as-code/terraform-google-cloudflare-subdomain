# Cloudflare Subdomain in Cloud DNS

Creating a Cloud DNS zone as sub-domain from a Cloudflare-hosted zone.

## Usage

```
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
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| cloudflare\_domain | Domain in Cloudflare | `string` | n/a | yes |
| cloudflare\_zone\_id | Cloudflare zone ID | `string` | n/a | yes |
| sub\_domain | sub-domain name | `string` | n/a | yes |
| ttl | TTL of the new sub-domain | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| dns\_name | DNS name of sub-domain |
| name\_servers | DNS name servers of the sub-domain |
| zone\_id | Zone ID of the new sub-domain |
