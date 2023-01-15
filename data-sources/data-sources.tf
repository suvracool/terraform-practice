/*
This tutorial depicts about the data sources in Terraform.
Data sources allow Terraform to use information defined outside of Terraform, defined by another separate 
Terraform configuration, or modified by functions.
*/
provider "aws" {
  region     = "us-west-2"
  access_key = var.access_key
  secret_key = var.secret_key
}

data "aws_ami" "app_ami" {
  most_recent = true

  owners = ["amazon"]


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "instance-1" {
    ami = data.aws_ami.app_ami.id
    instance_type="t2.micro"
}