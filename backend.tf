terraform {
  backend "s3" {
      bucket = "my-tf-test-bucket9234"
      key = "EC2/Demo/terraform.tf"
      region = "us-east-1"
  }
}
