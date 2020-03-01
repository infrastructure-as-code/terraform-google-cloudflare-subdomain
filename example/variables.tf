variable "cloudflare_api_key" {
  type        = string
  description = "Cloudflare API key"
}

variable "cloudflare_zone_id" {
  type        = string
  description = "Cloudflare zone ID"
}

variable "cloudflare_domain" {
  type        = string
  description = "Domain in Cloudflare"
}

variable "gcp_region" {
  type        = string
  description = "Google Cloud region"
}

variable "gcp_zone" {
  type        = string
  description = "Google Cloud zone"
}

variable "gcp_project_id" {
  type        = string
  description = "Google Cloud project ID"
}

variable "sub_domain" {
  type        = string
  description = "New sub-domain in Google Cloud DNS"
}
