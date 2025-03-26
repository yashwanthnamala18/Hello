terraform {
    
	backend "s3" {
 bucket = "my-tf-test-bucket9234"
 key    = "MLMounikaTest6/awsDemo/terraform.tfstate"
 region = "us-east-1"
  }
}
provider "aws" {
region = "us-east-1"
}
resource "aws_instance" "instance1" {
  ami           = "ami-08a0d1e16fc3f61ea"
  instance_type = "${{TERRAFORMTYPE}}"

  tags = {
    name = "My-Demo-Instances-Demo"
  }
}
