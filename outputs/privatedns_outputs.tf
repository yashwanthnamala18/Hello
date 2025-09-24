output "formatted_dns_records" {
  description = "Structured list of DNS records"
  value       = var.dns_records
}
 
output "dns_records_json" {
  description = "JSON-encoded DNS records for FlexDeploy/PowerShell"
  value       = jsonencode(var.dns_records)
}	
