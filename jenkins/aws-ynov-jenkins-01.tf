terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "eu-west-1"
}

resource "aws_instance" "jenkins-prod-01" {
  ami                    = "ami-01720b5f421cf0179"
  instance_type          = "t3.medium"
  key_name        		 = "sofiene-key-irlande-ynov"
  monitoring             = true
  vpc_security_group_ids = [
    "sg-05d1a251614fa89b7",
  ]
  user_data = file("install_jenkins.sh")
  tags                = {
    Name              = "jenkins-prod-01"
    environment       = "prod"
    shutdown_nightly  = "false"
    startup_daily     = "true"
  }
   root_block_device {
    delete_on_termination = false
  }
}
#####data jenkins
resource "aws_ebs_volume" "jenkins-prod-01" {
  availability_zone = "eu-west-1a"
  size              = 50
  type              = "gp2"
  tags = {
    Name              = "ebs-jenkins-prod-01"
    Environment       = "prod"
  }
}

resource "aws_volume_attachment" "ebs-jenkins-prod-01" {
  device_name = "/dev/xvdb"
  volume_id   = aws_ebs_volume.jenkins-prod-01.id
  instance_id = "i-059147220b365332b"
}

#Allow SSH and jenkins inbound traffic
resource "aws_security_group" "ynov-security-group" {
  name        = "ynov-security-group"
  description = "Allow SSH and Jenkins inbound traffic"
  vpc_id      = "vpc-93934eea"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
