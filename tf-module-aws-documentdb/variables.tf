variable "enabled" {
  type        = bool
  description = "Do you want to create Docdb"
  default     = true
}

variable "docdb_full_name" {
  type        = string
  description = "(Optional, Forces new resources) The cluster identifier. If omitted, Terraform will assign a random, unique identifier."
}

variable "engine" {
  type        = string
  description = "(Optional) The name of the database engine to be used for this DB cluster. Defaults to docdb. Valid Values: docdb"
  default     = "docdb"
}

variable "engine_version" {
  type        = string
  description = " (Optional) The database engine version. Updating this argument results in an outage."
  default     = "4.0"
}

variable "port" {
  type        = number
  description = "(Optional) The port on which the DB accepts connections"
  default     = 27017
}

variable "master_username" {
  type        = string
  description = " (Required unless a snapshot_identifier is provided) Username for the master DB user."
  default = "basworld"
}

variable "master_password" {
  type        = string
  description = " (Required unless a snapshot_identifier is provided) Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file. Please refer to the DocDB Naming Constraints."
  default = null
}

variable "apply_immediately" {
  type        = bool
  description = "(Optional) Specifies whether any cluster modifications are applied immediately, or during the next maintenance window. Default is false."
  default     = false
}

variable "storage_encrypted" {
  type        = bool
  description = "(Optional) Specifies whether the DB cluster is encrypted. The default is false."
  default     = true
}

variable "kms_key_id" {
  type        = string
  description = "(Optional) The ARN for the KMS encryption key. When specifying kms_key_id, storage_encrypted needs to be set to true."
  default     = null
}

variable "enabled_cloudwatch_logs_exports" {
  type        = list(string)
  description = "(Optional) List of log types to export to cloudwatch. If omitted, no logs will be exported. The following log types are supported: audit, profiler."
  default = [
    "audit",
    "profiler"
  ]
}

variable "deletion_protection" {
  type        = bool
  description = "(Optional) A value that indicates whether the DB cluster has deletion protection enabled. The database can't be deleted when deletion protection is enabled. By default, deletion protection is disabled."
  default     = false
}

variable "skip_final_snapshot" {
  type        = bool
  description = "(Optional) Determines whether a final DB snapshot is created before the DB cluster is deleted. If true is specified, no DB snapshot is created. If false is specified, a DB snapshot is created before the DB cluster is deleted, using the value from final_snapshot_identifier. Default is false."
  default     = true
}

variable "snapshot_identifier" {
  type        = string
  description = "(Optional) Specifies whether or not to create this cluster from a snapshot. You can use either the name or ARN when specifying a DB cluster snapshot, or the ARN when specifying a DB snapshot."
  default     = null
}

variable "backup_retention_period" {
  type        = number
  description = "(Optional) The days to retain backups for. Default 1"
  default     = 1
}

variable "preferred_backup_window" {
  type        = string
  description = "(Optional) The daily time range during which automated backups are created if automated backups are enabled using the BackupRetentionPeriod parameter.Time in UTC Default: A 30-minute window selected at random from an 8-hour block of time per region. e.g. 04:00-09:00"
  default     = "21:00-23:59"
}

variable "preferred_maintenance_window" {
  type        = string
  description = "(Optional) The weekly time range during which system maintenance can occur in (UTC) e.g., wed:04:00-wed:04:30"
  default     = "wed:04:00-wed:04:30"
}

variable "final_snapshot_identifier" {
  type        = string
  description = "(Optional) The name of your final DB snapshot when this DB cluster is deleted. If omitted, no final snapshot will be made."
  default     = null
}


variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
  default     = {}
}

############ Cluster Instance #########

/*variable "cluster_size" {
  type        = number
  default     = 1
  description = "Number of DB instances to create in the cluster"
}*/

variable "cluster_size" {
  type        = map(number)
  default     = {
      dev = 1 
      stg = 1
      prod = 3
}
  description = "Number of DB instances to create in the cluster"
}


variable "promotion_tier" {
  type        = number
  description = "(Optional) Default 0. Failover Priority setting on instance level. The reader who has lower tier has higher priority to get promoter to writer."
  default     = 0
}

variable "auto_minor_version_upgrade" {
  type        = bool
  description = "(Optional) Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window. Default true."
  default     = true
}

/*variable "instance_class" {
  type        = string
  default     = "db.t3.medium"
  description = "The instance class to use. For more details, see https://docs.aws.amazon.com/documentdb/latest/developerguide/db-instance-classes.html#db-instance-class-specs"
}*/

variable "instance_class" {
  type        = map(string)
  default     =  { 
        dev = "db.t3.medium"
        stg = "db.t3.medium"
        prod = "db.r5.xlarge"
}
  description = "The instance class to use. For more details, see https://docs.aws.amazon.com/documentdb/latest/developerguide/db-instance-classes.html#db-instance-class-specs"
}

variable "enable_performance_insights" {
  type        = map(bool)
  default     =  { 
        dev = false
        stg = false
        prod = true
}
  description = "A value that indicates whether to enable Performance Insights for the DB Instance."
}


###General

/*To DO:- Create subnet group specific to DocumentDB*/
variable "db_subnet_group_name" {
  type = map(string)

  default = {
    dev  = "rds-subnet-group-dev"
    stg  = "rds-subnet-group-stg"
    prod = "rds-subnet-group-prod"
  }
}

variable "environment_code" {
  description = "The workspace value."
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "VPC ID the DB instance will be created in."
  type        = string
  default     = null
}

variable "platform" {
  description = "Name of the bas platform. We have a page on [ confluence ]() that list all our platforms."
  type        = string
  default     = null
}



variable "account" {
  description = "Which account will be used."
  type        = string
  default     = null
}
#Cloudwatch

variable "sns_env" {
  description = "SNS alarm name"
  type        = map(string)

  default = {
    dev  = "non_prod"
    stg  = "non_prod"
    prod = "prod"
  }
}


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



