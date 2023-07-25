output database_username {
  description = "Username of the database."
  value       = local.schema_name
}

output database_password {
  description = "Password of the database."
  value       = random_password.password_application[0].result
}

output database_name {
  description = "Database name."
  value       = local.database_name
}

output schema_name {
  description = "Schema name."
  value       = local.schema_name
}

output migration_username {
  description = "Migration username."
  value       = local.user_map["mig_user"]
}

output migration_password {
  description = "Migration password."
  value       = random_password.password_application[0].result
}

output application_username {
  description = "Migration username."
  value       = local.user_map["app_user"]
}

output application_password {
  description = "Application password."
  value       = random_password.password_application[1].result
}

output ro_username {
  description = "Migration username."
  value       = local.user_map["ro_user"]
}

output ro_password {
  description = "RO password."
  value       = random_password.password_application[2].result
}



