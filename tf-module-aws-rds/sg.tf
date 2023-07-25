resource "aws_security_group" "service_rds" {
  name        = format("%s-sg", local.rds_full_name)
  description = format("Security group to RDS %s of %s", local.rds_type, local.rds_name)
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
  count                    = var.allow_instance_to_rds ? 1 : 0
  description              = format("bas service %s", local.rds_full_name)
  type                     = "ingress"
  from_port                = lookup(var.db_port, var.rds_engine_type)
  to_port                  = lookup(var.db_port, var.rds_engine_type)
  protocol                 = "TCP"
  source_security_group_id = var.security_group_id
  security_group_id        = aws_security_group.service_rds.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "sg_default_inbound_cidr" {
  count = var.sg_security ? length(local.sg_default_inbound_cidr) : 0

  type              = "ingress"
  protocol          = local.sg_default_inbound_cidr[count.index].protocol
  to_port           = local.sg_default_inbound_cidr[count.index].port
  from_port         = local.sg_default_inbound_cidr[count.index].port
  cidr_blocks       = [local.sg_default_inbound_cidr[count.index].cidr]
  security_group_id = aws_security_group.service_rds.id
  description       = "${local.sg_default_inbound_cidr[count.index].cidr} - Automatically generated."

  depends_on = [aws_security_group.service_rds]
    lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "sg_inbound_cidr" {
  count = var.sg_security ? length(local.sg_inbound_cidr) : 0

  type              = "ingress"
  protocol          = local.sg_inbound_cidr[count.index].protocol
  to_port           = local.sg_inbound_cidr[count.index].port
  from_port         = local.sg_inbound_cidr[count.index].port
  cidr_blocks       = local.sg_inbound_cidr[count.index].cidr != "0.0.0.0/0"? [local.sg_inbound_cidr[count.index].cidr]: null 
  security_group_id = aws_security_group.service_rds.id
  description       = "${local.sg_inbound_cidr[count.index].cidr} - Automatically generated."

  depends_on = [aws_security_group.service_rds]
}
