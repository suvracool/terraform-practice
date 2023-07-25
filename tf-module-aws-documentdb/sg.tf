


# Define security group
/*resource "aws_security_group" "example" {
  name_prefix = "example"
  vpc_id = data.aws_vpc.vpc_selected.id
  ingress {
    from_port = 27017
    to_port = 27017
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
} */



resource "aws_security_group" "service_docdb" {
  name        = format("%s-sg", local.docdb_full_name)
  description = format("Security group to DocumentDB  %s", local.docdb_full_name)
  vpc_id      = var.vpc_id == null ? data.aws_vpc.vpc_selected.id : var.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    #cidr_blocks = ["0.0.0.0/0", var.cidr_blocks[terraform.workspace]] ## todo : enable just internal aws blocks 
  }
  tags        = local.all_tags_lower

}


### security group aditional 
resource "aws_security_group_rule" "allow_instance_to_rds" {
  //count                    = var.allow_instance_to_rds ? 1 : 0
  description              = format("bas service %s", local.docdb_full_name)
  type                     = "ingress"
  from_port                = var.port
  to_port                  = var.port
  protocol                 = "TCP"
  cidr_blocks              = ["0.0.0.0/0"]
  //source_security_group_id = aws_security_group.service_docdb.id #Do we need this?
  security_group_id        = aws_security_group.service_docdb.id
  lifecycle {
    create_before_destroy = true
  }
}
