data "aws_sns_topic" "alarms_cloudwatch" {
  name = "alarms_cloudwatch_${var.sns_env[terraform.workspace]}"
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_too_high" {
  count               = var.create_high_cpu_alarm ? 1 : 0
  alarm_name          = "docdb-${local.docdb_full_name}-highCPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_period[terraform.workspace]
  metric_name         = "CPUUtilization"
  namespace           = "AWS/DocDB"
  period              = var.statistic_period[terraform.workspace]
  statistic           = "Average"
  threshold           = var.cpu_utilization_too_high_threshold[terraform.workspace]
  alarm_description   = "Average database CPU utilization is too high."
  alarm_actions       = [data.aws_sns_topic.alarms_cloudwatch.arn]
  ok_actions          = [data.aws_sns_topic.alarms_cloudwatch.arn]

  dimensions = {
    DBInstanceIdentifier = local.docdb_full_name
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_credit_balance_too_low" {
  count               = var.create_low_cpu_credit_alarm ? 1 : 0
  alarm_name          = "docdb-${local.docdb_full_name}-lowCPUCreditBalance"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_period[terraform.workspace]
  metric_name         = "CPUCreditBalance"
  namespace           = "AWS/DocDB"
  period              = var.statistic_period[terraform.workspace]
  statistic           = "Average"
  threshold           = var.cpu_credit_balance_too_low_threshold[terraform.workspace]
  alarm_description   = "Average database CPU credit balance is too low, a negative performance impact is imminent."
  alarm_actions       = [data.aws_sns_topic.alarms_cloudwatch.arn]
  ok_actions          = [data.aws_sns_topic.alarms_cloudwatch.arn]

  dimensions = {
    DBInstanceIdentifier = local.docdb_full_name
  }
}


resource "aws_cloudwatch_metric_alarm" "disk_queue_depth_too_high" {
  count               = var.create_high_queue_depth_alarm ? 1 : 0
  alarm_name          = "docdb-${local.docdb_full_name}-highDiskQueueDepth"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_period[terraform.workspace]
  metric_name         = "DiskQueueDepth"
  namespace           = "AWS/DocDB"
  period              = var.statistic_period[terraform.workspace]
  statistic           = "Average"
  threshold           = var.disk_queue_depth_too_high_threshold[terraform.workspace]
  alarm_description   = "Average database disk queue depth is too high, performance may be negatively impacted."
  alarm_actions       = [data.aws_sns_topic.alarms_cloudwatch.arn]
  ok_actions          = [data.aws_sns_topic.alarms_cloudwatch.arn]

  dimensions = {
    DBInstanceIdentifier = local.docdb_full_name
  }
}

resource "aws_cloudwatch_metric_alarm" "disk_free_storage_space_too_low" {
  count               = var.create_low_disk_space_alarm ? 1 : 0
  alarm_name          = "docdb-${local.docdb_full_name}-lowFreeStorageSpace"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_period[terraform.workspace]
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/DocDB"
  period              = var.statistic_period[terraform.workspace]
  statistic           = "Average"
  threshold           = var.disk_free_storage_space_too_low_threshold[terraform.workspace]
  alarm_description   = "Average database free storage space is too low and may fill up soon."
  alarm_actions       = [data.aws_sns_topic.alarms_cloudwatch.arn]
  ok_actions          = [data.aws_sns_topic.alarms_cloudwatch.arn]

  dimensions = {
    DBInstanceIdentifier = local.docdb_full_name
  }
}

resource "aws_cloudwatch_metric_alarm" "database_connections" {
  count               = var.create_database_connections_alarm ? 1 : 0
  alarm_name          = "docdb-${local.docdb_full_name}-databaseconnections"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_period[terraform.workspace]
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/DocDB"
  period              = var.statistic_period[terraform.workspace]
  statistic           = "Average"
  threshold           = var.database_connections_threshold[terraform.workspace]
  alarm_description   = "This alarm will trigger when the blue line goes outside the band for 1 datapoints within 5 minutes."
  alarm_actions       = [data.aws_sns_topic.alarms_cloudwatch.arn]
  ok_actions          = [data.aws_sns_topic.alarms_cloudwatch.arn]

  dimensions = {
    DBInstanceIdentifier = local.docdb_full_name
  }
}
