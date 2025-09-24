output "records_for_flexdeploy" {
  value = jsonencode([
    {
      action = "create-update"
      name   = "example-test.com"
      type   = "CNAME"
      value  = "www.example.com"
    }
  ])
}

output "simple_message" {
  value = "HelloFlexDeploy"
}
