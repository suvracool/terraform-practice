provider "aws" {
  region     = "us-west-2"
  access_key = "AKIATEKWXTCLCEXZHFJX"
  secret_key = "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"
}


resource "aws_instance" "update" {
  ami           = "ami-094125af156557ca2"
  instance_type = var.types["us-west-2"]

  tags = {
    Name = "HelloWorld"
  }

}