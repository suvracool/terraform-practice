output "sg_group_id" {
  description = "ID to RDS security group."
  value       = aws_security_group.service_rds.id
}

output "rds_endpoint" {
  description = "The connection endpoint."
  value       = concat(aws_db_instance.rds_this.*.endpoint, [""])[0]
}

output "rds_address" {
  description = "The address of the RDS instance."
  value       = aws_db_instance.rds_this.0.address
}

output "rds_name" {
  description = "The name of the RDS instance."
  value       = concat(aws_db_instance.rds_this.*.db_name, [""])[0]
}

output "rds_id" {
  description = "The RDS instance ID."
  value       = concat(aws_db_instance.rds_this.*.id, [""])[0]
}

output "rds_arn" {
  description = "The ARN of the RDS instance."
  value       = concat(aws_db_instance.rds_this.*.arn, [""])[0]
}

output "rds_password" {
  value = random_password.password.0.result
  # sensitive = true
}

output "engine_version" {
  description = "The database engine version."
  value       = concat(aws_db_instance.rds_this.*.engine_version, [""])[0]
}

output "engine" {
  description = "The database engine version."
  value       = concat(aws_db_instance.rds_this.*.engine, [""])[0]
}
output "rds_username" {
  description = "Rds username"
  value       = var.username
  # sensitive   = true
}

output "rds_values" {
  description = "RDS name and root password."
  #value       = map("user:%s pass: %s ", var.username, random_password.password.0.result)
  value       = tomap({
    "DATABASE_USERNAME" : var.username,
    "DATABASE_HOST" : aws_db_instance.rds_this.0.address
    "DATABASE_PASSWORD" : random_password.password.0.result
  })
  # sensitive   = true
}                              
