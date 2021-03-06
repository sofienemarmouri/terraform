variable "region" {
  default = "eu-west-1"
}
variable "environment" {
  default = "dev-ynov"
}
variable "vpc_cidr" {
  description = "VPC cidr block"
}
variable "public_subnet_1_cidr" {
  description = "Public Subnet 1 cidr block"
}
variable "public_subnet_2_cidr" {
  description = "Public Subnet 2 cidr block"
}
variable "public_subnet_3_cidr" {
  description = "Public Subnet 3 cidr block"
}
variable "private_subnet_1_cidr" {
  description = "Private Subnet 1 cidr block"
}
variable "private_subnet_2_cidr" {
  description = "Private Subnet 2 cidr block"
}
variable "private_subnet_3_cidr" {
  description = "Private Subnet 3 cidr block"
}
variable "instance_type" {
  description = "t2.micro"
}
variable "instance_ami" {
  description = data.aws_ami.amazon-linux-2.id
}
variable "keyname" {
  default ="sofiene-key-irlande-ynov"
}