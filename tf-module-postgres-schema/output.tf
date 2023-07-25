output database_username {
  description = "Username of the database."
  value       = local.schema_name
}

output database_password {
  description = "Password of the database."
  value       = random_password.password_application[local.user_names[0]].result
}

output database_name {
  description = "Database Name"
  value       = local.database_name
}

output migration_username {
  description = "Migration Username of the database."
  value       = local.user_names[0]
}
output migration_password {
  description = "Password of the migration user."
  value       = random_password.password_application[local.user_names[0]].result
}

output application_username {
  description = "Application Username of the database."
  value       = local.user_names[1]
}
output application_password {
  description = "Password of the application user."
  value       = random_password.password_application[local.user_names[1]].result
}

output ro_username {
  description = "RO Username of the database."
  value       = local.user_names[2]
}
output ro_password {
  description = "Password of the RO user."
  value       = random_password.password_application[local.user_names[2]].result
}
