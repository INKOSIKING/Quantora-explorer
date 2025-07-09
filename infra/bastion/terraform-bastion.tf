resource "aws_instance" "bastion" {
  ami           = "ami-0c55b159cbfafe1f0" # Hardened OS
  instance_type = "t3.micro"
  subnet_id     = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.bastion.id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y fail2ban auditd
    systemctl enable --now fail2ban auditd
    echo "AllowUsers devops security" >> /etc/ssh/sshd_config
    echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
    systemctl restart sshd
  EOF

  tags = {
    Name = "quantora-bastion"
  }
}

resource "aws_security_group" "bastion" {
  name        = "bastion-ssh"
  description = "Allow SSH only from office IP"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.office_ip_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}