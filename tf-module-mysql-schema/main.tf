resource "mysql_database" "rds" {
  name = local.database_name
}

resource "mysql_role" "rds_role_application" {
  name = local.schema_name
}

resource "mysql_user" "rds_user_migration" {
  for_each    =  toset( var.private_subnet_cdirs_list[terraform.workspace]) 
  host        = "${ each.value }"
  user               = local.user_map["mig_user"]
  plaintext_password = random_password.password_application[0].result
  
  lifecycle {
    ignore_changes = [plaintext_password]
  }
}

resource "mysql_grant" "role_migration" {
  for_each    =  toset( var.private_subnet_cdirs_list[terraform.workspace]) 
  host     = "${ each.value }"
  user     = "${mysql_user.rds_user_migration[each.key].user}"
  database = "${mysql_database.rds.name}"
  privileges = ["ALL PRIVILEGES"]
}

resource "mysql_user" "rds_user_application" {
  for_each    =  toset( var.private_subnet_cdirs_list[terraform.workspace]) 
  host        = "${ each.value }"
  user               = local.user_map["app_user"]
  plaintext_password = random_password.password_application[1].result
  
  lifecycle {
    ignore_changes = [plaintext_password]
  }
}

resource "mysql_grant" "role_application" {
  for_each    =  toset( var.private_subnet_cdirs_list[terraform.workspace]) 
  host     = "${ each.value }"
  user     = "${mysql_user.rds_user_application[each.key].user}"
  database = "${mysql_database.rds.name}"
  privileges = ["SELECT","INSERT","UPDATE","DELETE"]
}

resource "mysql_user" "rds_user_ro" {
  for_each    =  toset( var.private_subnet_cdirs_list[terraform.workspace]) 
  host        = "${ each.value }"
  user               = local.user_map["ro_user"]
  plaintext_password = random_password.password_application[2].result
  
  lifecycle {
    ignore_changes = [plaintext_password]
  }
}

resource "mysql_grant" "role_ro" {
  for_each    =  toset( var.private_subnet_cdirs_list[terraform.workspace]) 
  host     = "${ each.value }"
  user     = "${mysql_user.rds_user_ro[each.key].user}"
  database = "${mysql_database.rds.name}"
  privileges = ["SELECT"]
}





