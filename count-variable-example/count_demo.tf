/*
This example depicts about count variable.count is a meta-argument defined by the Terraform language.
It can be used with modules and with every resource type.
The count meta-argument accepts a whole number, and creates that many instances of the resource or module.
*/
provider "aws" {
  region     = "us-west-2"
  access_key = var.access_key
  secret_key = var.secret_key
}


resource "aws_instance" "update" {
  ami           = "ami-094125af156557ca2"
  instance_type = var.types["us-west-2"]
  count=2

  tags = {
    Name = "HelloWorld"
  }

}