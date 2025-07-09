provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "quantora_node" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t3.medium"

  tags = {
    Name = "QuantoraNode"
  }
}

resource "aws_security_group" "quantora_sg" {
  name        = "quantora_sg"
  description = "Allow Quantora node ports"
  ingress {
    from_port   = 30303
    to_port     = 30303
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 9944
    to_port     = 9944
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