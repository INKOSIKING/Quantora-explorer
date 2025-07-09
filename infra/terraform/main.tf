provider "aws" {
  region = "us-east-1"
}

resource "aws_ecs_cluster" "quantora" {
  name = "quantora-cluster"
}

resource "aws_db_instance" "db" {
  allocated_storage    = 20
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  name                 = "quantoradb"
  username             = "quantora"
  password             = "securepass"
  skip_final_snapshot  = true
}