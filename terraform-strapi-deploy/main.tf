provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "allow_strapi" {
  name        = "allow_strapi"
  description = "Allow HTTP, SSH, and Strapi ports"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "strapi" {
  ami                         = "ami-0f58b397bc5c1f2e8" # Ubuntu 22.04 in ap-south-1
  instance_type               = "t2.micro"
  key_name                    = "strapi-key" # Use your existing key pair name
  vpc_security_group_ids      = [aws_security_group.allow_strapi.id]
  user_data                   = file("${path.module}/user-data.sh")

  tags = {
    Name = "strapi-server"
  }
}

output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.strapi.public_ip
}
