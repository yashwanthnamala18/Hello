terraform {
	backend "s3" {
    bucket = "my-tf-test-bucket9234"
    key    = "MLMounikaTest1/awsDemo/terraform.tfstate"
    region = "us-east-1"
  }
}


