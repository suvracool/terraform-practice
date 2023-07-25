resource "aws_docdb_cluster" "this" {
  count = var.enabled ? 1 : 0

  cluster_identifier = var.name

  engine         = var.engine
  engine_version = var.engine_version
  port           = var.port

  master_username = var.master_username
  master_password = var.master_password


  apply_immediately = var.apply_immediately
  storage_encrypted = var.storage_encrypted
  kms_key_id        = var.storage_encrypted ? var.kms_key_id : null

  vpc_security_group_ids          = var.vpc_security_group_ids
  db_subnet_group_name            = local.db_subnet_group_name
  db_cluster_parameter_group_name = local.db_cluster_parameter_group_name

  
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  snapshot_identifier = var.snapshot_identifier
  deletion_protection = var.deletion_protection
  skip_final_snapshot = var.skip_final_snapshot

  backup_retention_period   = var.backup_retention_period
  preferred_backup_window   = var.preferred_backup_window
  final_snapshot_identifier = var.final_snapshot_identifier

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}


################### Subnet Group #######################################
resource "aws_docdb_subnet_group" "example" {
  name       = "example-subnet-group"
  subnet_ids = data.aws_subnet_ids.private.ids
}


# Define security group
resource "aws_security_group" "example" {
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
}
