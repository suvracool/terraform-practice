/*provider "aws" {
  region     = "us-west-2"
  access_key = var.access_key
  secret_key = var.secret_key
}*/

resource "aws_iam_user" "lb" {
    name = "loadbalancer.${count.index}"
    count = 3
    path = "/system/"
}