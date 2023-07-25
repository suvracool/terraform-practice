data "aws_sns_topic" "alarms_cloudwatch" {
  name = "alarms_cloudwatch_${var.sns_env[terraform.workspace]}"
}
resource "aws_cloudwatch_metric_alarm" "cpu_utilization_too_high" {
  count               = var.create_high_cpu_alarm ? 1 : 0
  alarm_name          = "alarm-rds-${local.rds_full_name}-high-cpu-tilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_period[terraform.workspace]
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = var.statistic_period[terraform.workspace]
  statistic           = "Average"
  threshold           = var.cpu_utilization_too_high_threshold[terraform.workspace]
  alarm_description   = "Average database CPU utilization is too high."
  alarm_actions       = [data.aws_sns_topic.alarms_cloudwatch.arn]
  ok_actions          = [data.aws_sns_topic.alarms_cloudwatch.arn]

  dimensions = {
    DBInstanceIdentifier = local.rds_full_name
  }
}
resource "aws_cloudwatch_metric_alarm" "cpu_credit_balance_too_low" {
  count               = var.create_low_cpu_credit_alarm ? 1 : 0
  alarm_name          = "alarm-rds-${local.rds_full_name}-low-cpu-creditbalance"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_period[terraform.workspace]
  metric_name         = "CPUCreditBalance"
  namespace           = "AWS/RDS"
  period              = var.statistic_period[terraform.workspace]
  statistic           = "Average"
  threshold           = var.cpu_credit_balance_too_low_threshold[terraform.workspace]
  alarm_description   = "Average database CPU credit balance is too low, a negative performance impact is imminent."
  alarm_actions       = [data.aws_sns_topic.alarms_cloudwatch.arn]
  ok_actions          = [data.aws_sns_topic.alarms_cloudwatch.arn]

  dimensions = {
    DBInstanceIdentifier = local.rds_full_name
  }
}
resource "aws_cloudwatch_metric_alarm" "disk_queue_depth_too_high" {
  count               = var.create_high_queue_depth_alarm ? 1 : 0
  alarm_name          = "alarm-rds-${local.rds_full_name}-high-diskqueuedepth"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_period[terraform.workspace]
  metric_name         = "DiskQueueDepth"
  namespace           = "AWS/RDS"
  period              = var.statistic_period[terraform.workspace]
  statistic           = "Average"
  threshold           = var.disk_queue_depth_too_high_threshold[terraform.workspace]
  alarm_description   = "Average database disk queue depth is too high, performance may be negatively impacted."
  alarm_actions       = [data.aws_sns_topic.alarms_cloudwatch.arn]
  ok_actions          = [data.aws_sns_topic.alarms_cloudwatch.arn]

  dimensions = {
    DBInstanceIdentifier = local.rds_full_name
  }
}
resource "aws_cloudwatch_metric_alarm" "disk_free_storage_space_too_low" {
  count               = var.create_low_disk_space_alarm ? 1 : 0
  alarm_name          = "alarm-rds-${local.rds_full_name}-low-freestoragespace"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_period[terraform.workspace]
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = var.statistic_period[terraform.workspace]
  statistic           = "Average"
  threshold           = var.disk_free_storage_space_too_low_threshold[terraform.workspace]
  alarm_description   = "Average database free storage space is too low and may fill up soon."
  alarm_actions       = [data.aws_sns_topic.alarms_cloudwatch.arn]
  ok_actions          = [data.aws_sns_topic.alarms_cloudwatch.arn]

  dimensions = {
    DBInstanceIdentifier = local.rds_full_name
  }
}

resource "aws_cloudwatch_metric_alarm" "disk_burst_balance_too_low" {
  count               = var.create_low_disk_burst_alarm ? 1 : 0
  alarm_name          = "alarm-rds-${local.rds_full_name}-low-ebs-burstbalance"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_period[terraform.workspace]
  metric_name         = "BurstBalance"
  namespace           = "AWS/RDS"
  period              = var.statistic_period[terraform.workspace]
  statistic           = "Average"
  threshold           = var.disk_burst_balance_too_low_threshold[terraform.workspace]
  alarm_description   = "Average database storage burst balance is too low, a negative performance impact is imminent."
  alarm_actions       = [data.aws_sns_topic.alarms_cloudwatch.arn]
  ok_actions          = [data.aws_sns_topic.alarms_cloudwatch.arn]

  dimensions = {
    DBInstanceIdentifier = local.rds_full_name
  }
}

resource "aws_cloudwatch_metric_alarm" "memory_swap_usage_too_high" {
  count               = var.create_swap_alarm ? 1 : 0
  alarm_name          = "alarm-rds-${local.rds_full_name}-high-swap-usage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_period[terraform.workspace]
  metric_name         = "SwapUsage"
  namespace           = "AWS/RDS"
  period              = var.statistic_period[terraform.workspace]
  statistic           = "Average"
  threshold           = var.memory_swap_usage_too_high_threshold[terraform.workspace]
  alarm_description   = "Average database swap usage is too high, performance may be negatively impacted."
  alarm_actions       = [data.aws_sns_topic.alarms_cloudwatch.arn]
  ok_actions          = [data.aws_sns_topic.alarms_cloudwatch.arn]

  dimensions = {
    DBInstanceIdentifier = local.rds_full_name
  }
}
resource "aws_cloudwatch_metric_alarm" "connection_count_anomalous" {
  count               = var.create_anomaly_alarm ? 1 : 0
  alarm_name          = "alarm-rds-${local.rds_full_name}-anomalous-connectioncount"
  comparison_operator = "GreaterThanUpperThreshold"
  evaluation_periods  = var.evaluation_period[terraform.workspace]
  threshold_metric_id = "e1"
  alarm_description   = "Anomalous database connection count detected. Something unusual is happening."
  alarm_actions       = [data.aws_sns_topic.alarms_cloudwatch.arn]
  ok_actions          = [data.aws_sns_topic.alarms_cloudwatch.arn]

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1, ${var.anomaly_band_width[terraform.workspace]})"
    label       = "DatabaseConnections (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "DatabaseConnections"
      namespace   = "AWS/RDS"
      period      = var.anomaly_period[terraform.workspace]
      stat        = "Average"
      unit        = "Count"

      dimensions = {
        DBInstanceIdentifier = local.rds_full_name
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "database_connections" {
  count               = var.create_database_connections_alarm ? 1 : 0
  alarm_name          = "alarm-rds-${local.rds_full_name}-databaseconnections"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_period[terraform.workspace]
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = var.statistic_period[terraform.workspace]
  statistic           = "Average"
  threshold           = var.database_connections_threshold[terraform.workspace]
  alarm_description   = "This alarm will trigger when the blue line goes outside the band for 1 datapoints within 5 minutes."
  alarm_actions       = [data.aws_sns_topic.alarms_cloudwatch.arn]
  ok_actions          = [data.aws_sns_topic.alarms_cloudwatch.arn]

  dimensions = {
    DBInstanceIdentifier = local.rds_full_name
  }
}                       
