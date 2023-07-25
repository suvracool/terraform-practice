data "aws_vpc" "vpc_selected" {
  filter {
    name   = "tag:Environment"
    values = [terraform.workspace]
  }

  filter {
    name   = "tag:Name"
    values = ["bas-platform-v2-${terraform.workspace}"]
  }
}
