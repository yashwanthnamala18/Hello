provider "aws" {
  region = "us-east-1"

}

resource "aws_instance" "instance1" {
  ami           = "ami-08a0d1e16fc3f61ea"
  instance_type = "t2.micro"

  tags = {
    name = "My-Demo-Instances"
  }

}
