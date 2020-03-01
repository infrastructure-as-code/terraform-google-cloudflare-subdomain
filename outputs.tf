output "name_servers" {
  value       = google_dns_managed_zone.sub.name_servers
  description = "DNS name servers of the sub-domain"
}

output "zone_id" {
  value       = google_dns_managed_zone.sub.id
  description = "Zone ID of the new sub-domain"
}

output "dns_name" {
  value       = local.sub_domain_dns_name
  description = "DNS name of sub-domain"
}
