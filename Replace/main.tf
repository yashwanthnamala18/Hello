output "records_for_flexdeplo" {
  value = jsonencode([
    {
      action = "create-update"
      name   = "example-test.com"
      type   = "CNAME"
      value  = "www.example.com"
    }
  ])
}
