output "records_for_flexdeploy" {
  value = base64encode(jsonencode([
    {
      action = "create-update"
      name   = "example-test.com"
      type   = "CNAME"
      value  = "www.example.com"
    }
  ]))
}
 
output "simple_message" {
  value = "HelloFlexDeploy"
}

output "records" {
  value = "action=create-update,name=example.com,type=CNAME,value=www.example.com"
}

output "new_records" {
  value = replace(base64encode(jsonencode([
    {
      action = "create-update"
      name   = "example.com"
      type   = "CNAME"
      value  = "www.example.com"
    }
  ])), "=", "-")
}

output "dns_records_delimited" {
  description = "Colon-separated, pipe-delimited DNS records for FlexDeploy"
  value = join("|", [
    for record in var.dns_records : "${record.action}:${record.name}:${record.type}:${record.value}"
  ])
}
