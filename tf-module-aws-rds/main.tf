resource "aws_db_instance" "rds_this" {
  count = local.create_rds ? 1 : 0

  identifier = local.rds_full_name

  allocated_storage     = local.allocated_storage
  max_allocated_storage = local.max_allocated_storage
  storage_type          = var.storage_type
  storage_encrypted     = var.storage_encrypted
  engine                = local.rds_engine_type
  engine_version        = lookup(var.engine_version, local.rds_engine_type) 
  instance_class        = local.rds_instance_class

  db_name     = lookup(var.database_name, local.rds_engine_type) 
  username = local.username
  password = local.password
  port     = lookup(var.db_port, local.rds_engine_type)

  vpc_security_group_ids = local.aws_security_group
  db_subnet_group_name   = local.rds_db_subnet_group_name
  multi_az               = local.rds_multi_az
  replicate_source_db    = var.replicate_source_db


  backup_retention_period    = local.backup_retention_period
  deletion_protection        = var.deletion_protection
  skip_final_snapshot        = var.skip_final_snapshot
  final_snapshot_identifier  = local.final_snapshot_identifier
  auto_minor_version_upgrade = local.rds_auto_minor_version_upgrade
  copy_tags_to_snapshot      = var.copy_tags_to_snapshot

  performance_insights_enabled = local.rds_performance_insights_enabled

  enabled_cloudwatch_logs_exports = local.enabled_cloudwatch_logs_exported[local.rds_engine_type]

  tags = local.all_tags_lower

  lifecycle {
    ignore_changes = [password]
  }

  depends_on = [aws_security_group.service_rds]
}
