data "aws_security_groups" "additional_aws_security_group_name_list" {
  count = length(var.additional_aws_security_group_name_list)

  filter {
    name   = var.sg_filter
    values = [var.additional_aws_security_group_name_list[count.index]]
  }
}

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
