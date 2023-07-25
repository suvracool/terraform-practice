locals {
  create_rds = lookup(var.create_rds_map, var.environment_code)
  rds_name                         = lower(var.rds_name)
  rds_engine_type                  = var.rds_engine_type
  rds_type                         = format("%s-%s", var.replicate_source_db == null ? "${var.rds_engine_type}" : "readreplica-${var.rds_engine_type}", var.environment_code)
  rds_full_name                    = format("%s-service-%s", local.rds_name, local.rds_type)
  name_database                    = format("%s_service", replace(local.rds_name, "-", "_"))
  username                         = var.replicate_source_db == null ? var.username : null
  final_snapshot_identifier        = var.replicate_source_db == null ? format("%s-final-snapshot", local.rds_full_name) : null
  password                         = var.replicate_source_db == null && local.create_rds ? random_password.password.0.result : null
  allocated_storage                = lookup(var.allocated_storage, var.environment_code)
  max_allocated_storage            = var.max_allocated_storage == null ? 1.5 * local.allocated_storage : var.max_allocated_storage
  rds_auto_minor_version_upgrade   = lookup(var.auto_minor_version_upgrade, var.environment_code)
  rds_instance_class               = lookup(var.instance_class, var.environment_code)
  rds_multi_az                     = var.replicate_source_db == null ? lookup(var.multi_az, var.environment_code) : false
  rds_performance_insights_enabled = lookup(var.performance_insights_enabled, var.environment_code)
  enabled_cloudwatch_logs_exported = var.enabled_cloudwatch_logs_exported
  backup_retention_period          = var.replicate_source_db == null ? 15 : 0

  rds_db_subnet_group_name = lookup(var.db_subnet_group_name, var.environment_code)

  aws_security_group = var.additional_aws_security_group_name_list != [""] ? flatten([
    [data.aws_security_groups.additional_aws_security_group_name_list[*].ids],
    [aws_security_group.service_rds.id]
  ]) : [aws_security_group.service_rds.id]

  local_tags = {
    Name        = local.rds_full_name
    module_name = "aws-rds"
  }

  tags = merge(
    var.tags,
    local.local_tags
  )

  all_tags_lower = { for k, v in local.tags : k => lower(v) }
  
  sg_init_default_inbound_cidr = {
    dev = {
        "10.32.0.0/16"   = { "tcp" = ["${lookup(var.db_port, var.rds_engine_type)}"] },  #RDS DEV ACCOUNT SUBNET ACCESS
        "10.16.0.0/16"   = { "tcp" = ["${lookup(var.db_port, var.rds_engine_type)}"] },  #RDS VPN USER ACCESS  
        "172.16.33.0/24" = { "tcp" = ["${lookup(var.db_port, var.rds_engine_type)}"] },  #RDS ONPRIMEN VPN ACCESS 
        "172.16.34.0/24" = { "tcp" = ["${lookup(var.db_port, var.rds_engine_type)}"] }   #RDS ONPRIMEN VPN ACCESS
        "100.64.0.0/16"  = { "tcp" = ["${lookup(var.db_port, var.rds_engine_type)}"] }   #Pod Networks
        "172.17.0.0/16" = { "tcp" = ["${lookup(var.db_port, var.rds_engine_type)}"] },  #RDS OFFICE VPN ACCESS
        "172.20.105.0/24" = { "tcp" = ["${lookup(var.db_port, var.rds_engine_type)}"] },  #RDS OFFICE VPN ACCESS
      }
    
    stg = {
        "10.24.0.0/16"   = { "tcp" = ["${lookup(var.db_port, var.rds_engine_type)}"] }, #RDS STG ACCOUNT SUBNET ACCESS 
        "10.16.0.0/16"   = { "tcp" = ["${lookup(var.db_port, var.rds_engine_type)}"] },   #RDS VPN USER ACCESS 
        "172.16.33.0/24" = { "tcp" = ["${lookup(var.db_port, var.rds_engine_type)}"] },  #RDS ONPRIMEN VPN ACCESS 
        "172.16.34.0/24" = { "tcp" = ["${lookup(var.db_port, var.rds_engine_type)}"] }   #RDS ONPRIMEN VPN ACCESS
        "100.64.0.0/16"  = { "tcp" = ["${lookup(var.db_port, var.rds_engine_type)}"] }   #Pod Networks
        "172.17.0.0/16" = { "tcp" = ["${lookup(var.db_port, var.rds_engine_type)}"] },  #RDS OFFICE VPN ACCESS
        "172.20.105.0/24" = { "tcp" = ["${lookup(var.db_port, var.rds_engine_type)}"] },  #RDS OFFICE VPN ACCESS
      }

   
    prod = {
        "10.16.0.0/16" = { "tcp" = ["${lookup(var.db_port, var.rds_engine_type)}"] },    #RDS PROD ACCOUNT SUBNET ACCESS 
        "172.16.31.0/24" = { "tcp" = ["${lookup(var.db_port, var.rds_engine_type)}"] },  #RDS ONPREM  VPN ACCESS  
        "172.16.32.0/24" = { "tcp" = ["${lookup(var.db_port, var.rds_engine_type)}"] },  #RDS ONPRIMEN VPN ACCESS
        "100.64.0.0/16"  = { "tcp" = ["${lookup(var.db_port, var.rds_engine_type)}"] }   #Pod Networks
      }

    }
 

  sg_default_inbound_cidr = flatten([
    for cidr, value in local.sg_init_default_inbound_cidr[terraform.workspace] : [
      for protocol, pvalue in value : [
        for port in pvalue : {
          cidr     = cidr
          protocol = protocol
          port     = port
        }
      ]
    ]
  ])

  sg_inbound_cidr = flatten([
    for cidr, value in var.sg_inbound_cidr : [
      for protocol, pvalue in value : [
        for port in pvalue : {
          cidr     = cidr
          protocol = protocol
          port     = port
        }
      ]
    ]
  ])



}
