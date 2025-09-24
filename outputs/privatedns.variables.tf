variable "dns_records" {
  description = "List of DNS records to manage"
  type = list(object({
    action = string # "create-update" or "delete"
    type   = string # DNS record type: "A" or "CNAME"
    name   = string # FQDN of the record
    value  = string # Value based on type: IP address or FQDN
  }))
 
  validation {
    condition     = length(var.dns_records) > 0 && length(var.dns_records) <= 20
    error_message = "The dns_records list must contain at least 1 record and no more than 20 records."
  }
 
  validation {
    condition = alltrue([
      for record in var.dns_records : contains(["create-update", "delete"], record.action)
    ])
    error_message = "Each DNS record action must be one of: 'create-update' or 'delete'."
  }
 
  validation {
    condition = alltrue([
      for record in var.dns_records : contains(["A", "CNAME"], record.type)
    ])
    error_message = "Each DNS record type must be one of: 'A' or 'CNAME'."
  }
 
  validation {
    condition = alltrue([
      for record in var.dns_records : can(regex("^[a-zA-Z0-9]([a-zA-Z0-9\\-]{0,61}[a-zA-Z0-9])?([.][a-zA-Z0-9]([a-zA-Z0-9\\-]{0,61}[a-zA-Z0-9])?)*\\.(sficorp\\.com|schreiberfoods\\.com)\\.?$", record.name))
    ])
    error_message = "Each DNS record name must be a valid FQDN ending in either .sficorp.com or .schreiberfoods.com."
  }
 
  validation {
    condition = alltrue([
      for record in var.dns_records : (
        # A record - IPv4 address
        (record.type == "A" && can(regex("^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", record.value))) ||
        # CNAME record - any valid FQDN
        (record.type == "CNAME" && can(regex("^[a-zA-Z0-9]([a-zA-Z0-9\\-]{0,61}[a-zA-Z0-9])?([.][a-zA-Z0-9]([a-zA-Z0-9\\-]{0,61}[a-zA-Z0-9])?)*[.]?$", record.value)))
      )
    ])
    error_message = "Each DNS record value must match the format required for its type: A (IPv4), CNAME (any valid FQDN)."
  }
 
  validation {
    condition = alltrue([
      for record in var.dns_records : (
        record.type != "A" || (
          # Check if IP is in 10.85.0.0/16 (10.85.0.0 - 10.85.255.255)
          can(regex("^10\\.85\\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])$", record.value)) ||
          # Check if IP is in 10.86.0.0/16 (10.86.0.0 - 10.86.255.255)
          can(regex("^10\\.86\\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])$", record.value)) ||
          # Check if IP is in 10.87.0.0/16 (10.87.0.0 - 10.87.255.255)
          can(regex("^10\\.87\\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])$", record.value))
        )
      )
    ])
    error_message = "A record IP addresses must be within one of the AWS subnets: 10.85.0.0/16, 10.86.0.0/16, or 10.87.0.0/16."
  }
}
