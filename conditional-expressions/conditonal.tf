provider "aws" {
  region     = "us-west-2"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_instance" "dev" {
  ami           = "ami-094125af156557ca2"
  instance_type = var.types["dev"]
  count = var.is_test == true  ? 1 : 0

}

resource "aws_instance" "prod" {
  ami           = "ami-094125af156557ca2"
  instance_type = var.types["prod"]
  count = var.is_test == false  ? 2 : 0

}