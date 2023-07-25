variable "rds_name" {
  description = "This is the human-redable name of the rds."
  type        = string
  default     = null
}

variable "platform" {
  description = "Name of the bas platform. We have a page on [ confluence ]() that list all our platforms."
  type        = string
  default     = null
}

variable "environment_code" {
  description = "The workspace value."
  type        = string
  default     = null
}

variable "account" {
  description = "Which account will be used."
  type        = string
  default     = null
}

variable "allow_instance_to_rds" {
  description = "allow use aditional security group for rds"
  type        = bool
  default     = false
}
variable "allocated_storage" {
  description = "The allocated storage in gigabytes."
  type        = map(string)

  default = {
    dev  = "20"
    stg  = "20"
    prod = "100"
  }
}
variable "sns_env" {
  description = "SNS alarm name"
  type        = map(string)

  default = {
    dev  = "non_prod"
    stg  = "non_prod"
    prod = "prod"
  }
}

variable "max_allocated_storage" {
  description = "Specifies the value for Storage Autoscaling"
  type        = number
  default     = null
}

variable "storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'standard' if not. Note that this behaviour is different from the AWS web console, where the default is 'gp2'."
  type        = string
  default     = "gp2"
}

variable "engine" {
  description = "The database engine to use. Default in basworld is mysql. optional is postgress"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "The engine version to use. Default for postgress is  '10' and mysql is '8.0.23'"
  type        = any
  default = {
    mysql    = "8.0.32"
    postgres = "14.5"
  }
}

variable "database_name" {
  description = "The DB name to create."
  type        = map(string)
  default     = {
    mysql = "mysqlroot"
    postgres = "postgres"
  }
}

variable "username" {
  description = "Username for the master DB user."
  type        = string
  default     = "basworld"
}

variable "password" {
  description = "Password for the master DB user"
  type        = string
  default     = null
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier."
  type        = bool
  default     = false
}

variable "copy_tags_to_snapshot" {
  description = "On delete, copy all Instance tags to the final snapshot (if final_snapshot_identifier is specified)."
  type        = bool
  default     = true
}

variable "db_port" {
  description = "The port on which the DB accepts connections."
  type        = map(number)
  default = {
    mysql    = 3306
    postgres = 5432
  }
}

variable "backup_retention_period" {
  description = "The days to retain backups for(Replica use 0 days)."
  type        = number
  default     = 15
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted."
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "The database can't be deleted when this value is set to true."
  type        = bool
  default     = true
}

variable "replicate_source_db" {
  description = "Specifies that this resource is a Replicate database, and to use this value as the source database. This correlates to the identifier of another Amazon RDS Database to replicate."
  type        = string
  default     = null
}

variable "security_group_id" {
  description = "The IDs of the security groups from which to allow ingress traffic to the DB instance."
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "VPC ID the DB instance will be created in."
  type        = string
  default     = null
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window."
  type        = map(bool)

  default = {
    dev  = false
    stg  = false
    prod = false
  }
}

variable "instance_class" {
  description = "The instance type of the RDS instance."
  type        = map(string)
  default = {
    dev  = "db.t3.micro"
    stg  = "db.t3.medium"
    prod = "db.m5.large"
  }
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ."
  type        = map(bool)

  default = {
    dev  = false
    stg  = false
    prod = true
  }
}

variable "db_subnet_group_name" {
  type = map(string)

  default = {
    dev  = "rds-subnet-group-dev"
    stg  = "rds-subnet-group-stg"
    prod = "rds-subnet-group-prod"
  }
}

variable "performance_insights_enabled" {
  type = map(bool)

  default = {
    dev  = false
    stg  = true
    prod = true
  }
}

variable "create_rds_map" {
  type = map(bool)

  default = {
    dev  = true
    stg  = true
    prod = true
  }
}

variable "enabled_cloudwatch_logs_exported" {
  description = "List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine):  MySQL and MariaDB: audit, error, general, slowquery. PostgreSQL: postgresql, upgrade. MSSQL: agent , error. Oracle: alert, audit, listener, trace"

  default = {
    mysql       = ["audit", "error", "general", "slowquery"]
    postgres = ["upgrade"]
  }
}

variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
  default     = {}
}


variable "rds_engine_type" {
  description = "rds engine type"
  default     = ""
  type        = string
  validation {
    condition     = contains(["mysql", "postgres"], var.rds_engine_type)
    error_message = "Argument \"rds_engine_type\" must be either \"mysql\",or \"postgres\"."
  }
}

variable "additional_aws_security_group_name_list" {
  description = "Additional security group names list" # Ex: additional_aws_security_group_name_list = [ "communication-sg", "my-sg-name" ]
  type        = list(string)
  default     = []
}

/*filter sg group name  */
variable "sg_filter" {
  type        = string
  description = "Specify the aws filter to find the security group desired. Ex: group-name, tag:Service"
  default     = "group-name"
}

variable "sg_security" {
  type        = bool
  description = "This flag describes if the application needs to use security group's . If true, a security group with default rules will be created."
  default     = "true"
}

variable "sg_inbound_cidr" {
  type        = map(any)
  description = "allow INBOUND security group rules by CIDR. IPAM LIST https://bas-tech.atlassian.net/wiki/spaces/PEW/pages/202932225/AWS+Network+Definitions#IPAM-TABLE" # Ex: { "10.6.0.0/16" = { "tcp" = ["80", "443"] } }
  default     = {}
}

#Cloudwatch
variable "evaluation_period" {
  description = "The evaluation period over which to use when triggering alarms."
  type    = map(string)
  default = {
    dev  = "5"
    stg  = "5"
    prod = "5"
  }
}
variable "statistic_period" {
  description = "The number of seconds that make each statistic period."
  type    = map(string)
  default = {
    dev  = "60"
    stg  = "60"
    prod = "60"
  }
}

variable "create_high_cpu_alarm" {
  type        = bool
  default     = true
  description = "Whether or not to create the high cpu alarm.  Default is to create it (for backwards compatible support)"
}

variable "create_low_cpu_credit_alarm" {
  type        = bool
  default     = true
  description = "Whether or not to create the low cpu credit alarm.  Default is to create it (for backwards compatible support)"
}

variable "create_high_queue_depth_alarm" {
  type        = bool
  default     = true
  description = "Whether or not to create the high queue depth alarm.  Default is to create it (for backwards compatible support)"
}

variable "create_low_disk_space_alarm" {
  type        = bool
  default     = true
  description = "Whether or not to create the low disk space alarm.  Default is to create it (for backwards compatible support)"
}

variable "create_low_disk_burst_alarm" {
  type        = bool
  default     = true
  description = "Whether or not to create the low disk burst alarm.  Default is to create it (for backwards compatible support)"
}

variable "create_swap_alarm" {
  type        = bool
  default     = true
  description = "Whether or not to create the high swap usage alarm.  Default is to create it (for backwards compatible support)"
}

variable "create_anomaly_alarm" {
  type        = bool
  default     = true
  description = "Whether or not to create the fairly noisy anomaly alarm.  Default is to create it (for backwards compatible support), but recommended to disable this for non-production databases"
}
variable "anomaly_period" {
  description = "The number of seconds that make each evaluation period for anomaly detection."
  type    = map(string)
  default = {
    dev  = "600"
    stg  = "600"
    prod = "600"
  }
}
variable "anomaly_band_width" {
  description = "The width of the anomaly band, default 2.  Higher numbers means less sensitive."
  type    = map(string)
  default = {
    dev  = "2"
    stg  = "2"
    prod = "2"
  }
}

variable "cpu_utilization_too_high_threshold" {
  description = "Alarm threshold for the 'highCPUUtilization' alarm"
  type    = map(string)
  default = {
    dev  = "99"
    stg  = "95"
    prod = "80"
  }
}
variable "cpu_credit_balance_too_low_threshold" {
  description = "Alarm threshold for the 'lowCPUCreditBalance' alarm"
  type    = map(string)
  default = {
    dev  = "25"
    stg  = "25"
    prod = "75"
  }
}
variable "disk_queue_depth_too_high_threshold" {
  description = "Alarm threshold for the 'highDiskQueueDepth' alarm"
  type    = map(string)
  default = {
    dev  = "64"
    stg  = "64"
    prod = "64"
  }
}
variable "disk_burst_balance_too_low_threshold" {
  description = "Alarm threshold for the 'lowEBSBurstBalance' alarm"
  type    = map(string)
  default = {
    dev  = "25"
    stg  = "25"
    prod = "70"
  }
}
variable "disk_free_storage_space_too_low_threshold" {
  description = "Alarm threshold for the 'lowFreeStorageSpace' alarm"
  type    = map(string)
  default = {
    dev  = "10000000000" // 10 GB
    stg  = "10000000000" // 10 GB
    prod = "10000000000" // 10 GB
  }
}

variable "memory_swap_usage_too_high_threshold" {
  description = "Alarm threshold for the 'highSwapUsage' alarm"
  type    = map(string)
  default = {
    dev  = "256000000" // 256 MB
    stg  = "256000000" // 256 MB
    prod = "256000000" // 256 MB
  }
}
variable "create_database_connections_alarm" {
  type        = bool
  default     = true
  description = "Whether or not to create the high cpu alarm.  Default is to create it (for backwards compatible support)"
}
variable "database_connections_threshold" {
  description = "Alarm threshold for the 'anomaly detection' alarm"
  type    = map(string)
  default = {
    dev  = "2"
    stg  = "2"
    prod = "2"
  }
}                                         
