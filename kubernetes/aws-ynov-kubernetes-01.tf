provider "aws" {
  profile = "default"
  region  = "eu-west-1"
}

resource "aws_instance" "kubernetes-prod-01" {
  availability_zone      = "eu-west-1a"
  ami                    = "ami-08a3bf0ca5cb00159"
  instance_type          = "t3.small"
  key_name        		 = "sofiene-key-irlande-ynov"
  monitoring             = true
  vpc_security_group_ids = [
    "sg-05d1a251614fa89b7",
  ]
  user_data = file("install-env.sh")
#  user_data = file("install_docker_and_kubernetes.sh")
  tags          = {
    Name              = "kubernetes-prod-01"
    environment       = "production"
    shutdown_nightly  = "false"
    startup_daily     = "true"
  }
   root_block_device {
    delete_on_termination = false
  }
}