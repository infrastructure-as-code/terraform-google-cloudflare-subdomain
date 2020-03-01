variable "cloudflare_zone_id" {
  type        = string
  description = "Cloudflare zone ID"
}

variable "cloudflare_domain" {
  type        = string
  description = "Domain in Cloudflare"
}

variable "sub_domain" {
  type        = string
  description = "sub-domain name"
}

variable "ttl" {
  type        = number
  description = "TTL of the new sub-domain"
  default     = 1
}
