variable "instance_name" {
	description = "The EC2 instance name"
	default = "postgress"
}

variable "postgres_port" {
	description = "The port number used postgres database"
	default = 5432
}

variable "postgres_password" {
	description = "The password used for postgres database"
	default = "welcome1"
}

data "aws_availability_zones" "all" {}

provider "aws" {
	region = "us-east-1"
}

resource "aws_instance" "postgress" {
  ami = "ami-0c6b1d09930fac512"
  instance_type = "t2.micro"
  
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]
  key_name = "joel-ec2-kp"
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y docker
			  sudo service docker start
			  sudo usermod -aG docker ec2-user
			  sudo docker run --name postgres-fd -p ${var.postgres_port}:5432 -e POSTGRES_PASSWORD=${var.postgres_password} -e POSTGRES_DB=flexdeploy -d joelwenzel/postgres-fd:latest
              EOF
  tags {
    Name = "${var.instance_name}"
  }
}

resource "aws_security_group" "instance" {
  name = "flexagon-instance"
  ingress {
    from_port = "${var.postgres_port}"
    to_port = "${var.postgres_port}"
    protocol = "tcp"
    cidr_blocks = ["98.102.83.134/32"]
  }
  
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["98.102.83.134/32"]
  }
  
  egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

output "postgres_url" {
  value = "jdbc:postgresql://${aws_instance.postgress.public_ip}:${var.postgres_port}/flexdeploy"
}
