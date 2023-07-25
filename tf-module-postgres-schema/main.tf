resource "postgresql_database" "rds" {
  name = local.database_name
   
}









# CREATE ROLE <dbname>_service LOGIN INHERIT PASSWORD '';
# CREATE ROLE <dbname>_application LOGIN INHERIT PASSWORD '';
# CREATE ROLE <dbname>_ro LOGIN INHERIT PASSWORD '';

resource "postgresql_role" "rds_user_application" {
  
  
  for_each = toset(local.user_names)
  name     = each.key
  password = random_password.password_application[each.key].result

  

  
  login       = true
  search_path = [local.schema_name]


  lifecycle {
    ignore_changes = [password,roles]
  }
}


#REVOKE ALL ON schema PUBLIC from PUBLIC;

resource "postgresql_grant" "revoke_public" {
  database    = local.database_name
  role        = "public"
  schema      = "public"
  object_type = "schema"
  privileges  = []

  depends_on = [
    postgresql_database.rds
  ]
}

#GRANT <dbname>_quickstart_service to basworld;
#Replace basworld with parameter coming from root rds module
resource "postgresql_grant_role" "grant_migration_to_master" {
  role       = "basworld"
  grant_role = local.my_map["mig_user"]

 depends_on = [
    postgresql_schema.schema_application
  ]
}

# resource "postgresql_role" "rds_user_migration" {
#   name        = local.mig_user
#   password    = random_password.password_application.result
#   login       = true
#   search_path = [local.schema_name]


#   lifecycle {
#     ignore_changes = [password]
#   }
# }

#CREATE SCHEMA <schemaname> AUTHORIZATION <username>
resource "postgresql_schema" "schema_application" {
  name     = local.schema_name
  database = local.database_name
  policy {
    create_with_grant = true
    usage_with_grant  = true
    role              = local.my_map["mig_user"]
  }

  depends_on = [
    postgresql_database.rds
  ]
}


#GRANT CONNECT ON DATABASE <dbname> TO <dbname>_service;
#GRANT CONNECT ON DATABASE <dbname> TO <dbname>_application;
#GRANT CONNECT ON DATABASE <dbname> TO <dbname>_ro;

resource "postgresql_grant" "database_connect" {
  count = length(local.user_names)
  database    = local.database_name
 
  role        = local.user_names[count.index]
  object_type = "database"
  privileges  = ["CONNECT"]

  depends_on = [
    postgresql_database.rds
  ]
}

#########################################################################################################################
# Grants for migration(_service) user

#GRANT ALL ON SCHEMA  <schemaname> TO <dbname>_service;

resource "postgresql_grant" "schema_privileges_migration_user" {
  database    = local.database_name
  role        = local.my_map["mig_user"]
  schema      = local.schema_name
  object_type = "schema"  
  privileges  = ["USAGE","CREATE"]
  

  depends_on = [
    postgresql_schema.schema_application
  ]
}

#GRANT ALL ON ALL TABLES IN SCHEMA <schemaname> TO  <dbname>_service;
resource "postgresql_grant" "table_privileges_migration_user" {
  database    = local.database_name
  role        = local.my_map["mig_user"]
  schema      = local.schema_name
  object_type = "table" 
  objects     = [] 
  privileges  = ["SELECT","INSERT","UPDATE","DELETE","TRUNCATE","REFERENCES","TRIGGER"]

  depends_on = [
    postgresql_schema.schema_application
  ]
}

#GRANT ALL ON ALL SEQUENCES IN SCHEMA <schemaname> TO <dbname>_service;
resource "postgresql_grant" "sequence_privileges_migration_user" {
  database    = local.database_name
  role        = local.my_map["mig_user"]
  schema      = local.schema_name
  object_type = "sequence" 
  objects     = [] 
  privileges  = ["USAGE","SELECT","UPDATE"]

  depends_on = [
    postgresql_schema.schema_application
  ]
}

#ALTER DEFAULT PRIVILEGES FOR ROLE <dbname>_service IN SCHEMA <schemaname> GRANT ALL  ON TABLES TO <dbname>_service;

resource "postgresql_default_privileges" "table_default_privileges_migration_user" {
  role     = local.my_map["mig_user"]
  database = local.database_name
  schema   = local.schema_name
  owner       = local.my_map["mig_user"]
  object_type = "table"
  privileges  = ["SELECT","INSERT","UPDATE","DELETE","TRUNCATE","REFERENCES","TRIGGER"]

  depends_on = [
    postgresql_schema.schema_application
  ]
}

#ALTER DEFAULT PRIVILEGES FOR ROLE <dbname>_service IN SCHEMA <schemaname> GRANT ALL ON SEQUENCES TO <dbname>_service;
resource "postgresql_default_privileges" "sequence_default_privileges_migration_user" {
  role     = local.my_map["mig_user"]
  database = local.database_name
  schema   = local.schema_name
  owner       = local.my_map["mig_user"]
  object_type = "sequence"
  privileges  = ["USAGE","SELECT","UPDATE"]

  depends_on = [
    postgresql_schema.schema_application
  ]
}

#########################################################################################################################
# Grants for application (_application) user
#GRANT USAGE ON SCHEMA  <schemaname> TO <dbname>_application;

resource "postgresql_grant" "schema_privileges_application_user" {
  database    = local.database_name
  role        = local.my_map["app_user"]
  schema      = local.schema_name
  object_type = "schema"  
  privileges  = ["USAGE"]
  

  depends_on = [
    postgresql_schema.schema_application
  ]
}

#GRANT SELECT,INSERT,UPDATE,DELETE ON ALL TABLES IN SCHEMA <schemaname> TO  <dbname>_application;
resource "postgresql_grant" "table_privileges_application_user" {
  database    = local.database_name
  role        = local.my_map["app_user"]
  schema      = local.schema_name
  object_type = "table" 
  objects     = [] 
  privileges  = ["SELECT","INSERT","UPDATE","DELETE"]

  depends_on = [
    postgresql_schema.schema_application
  ]
}


#GRANT USAGE,SELECT ON ALL SEQUENCES IN SCHEMA <schemaname> TO <dbname>_application;
resource "postgresql_grant" "sequence_privileges_application_user" {
  database    = local.database_name
  role        = local.my_map["app_user"]
  schema      = local.schema_name
  object_type = "sequence" 
  objects     = [] 
  privileges  = ["USAGE","SELECT"]

  depends_on = [
    postgresql_schema.schema_application
  ]
}


#ALTER DEFAULT PRIVILEGES FOR ROLE <dbname>_service IN SCHEMA <schemaname> GRANT ALL  ON TABLES TO <dbname>_service;

resource "postgresql_default_privileges" "table_default_privileges_application_user" {
  role     = local.my_map["app_user"]
  database = local.database_name
  schema   = local.schema_name
  owner       = local.my_map["mig_user"]
  object_type = "table"
  privileges  = ["SELECT","INSERT","UPDATE","DELETE"]

  depends_on = [
    postgresql_schema.schema_application
  ]
}

#ALTER DEFAULT PRIVILEGES FOR ROLE <dbname>_service IN SCHEMA <schemaname> GRANT USAGE,SELECT ON SEQUENCES TO <dbname>_service;
resource "postgresql_default_privileges" "sequence_default_privileges_application_user" {
  role     = local.my_map["app_user"]
  database = local.database_name
  schema   = local.schema_name
  owner       = local.my_map["mig_user"]
  object_type = "sequence"
  privileges  = ["USAGE","SELECT"]

  depends_on = [
    postgresql_schema.schema_application
  ]
}

#########################################################################################################################
# Grants for read only(_ro) user

#GRANT USAGE ON SCHEMA  <schemaname> TO <dbname>_ro;

resource "postgresql_grant" "schema_privileges_ro_user" {
  database    = local.database_name
  role        = local.my_map["ro_user"]
  schema      = local.schema_name
  object_type = "schema"  
  privileges  = ["USAGE"]
  

  depends_on = [
    postgresql_schema.schema_application
  ]
}

#GRANT SELECT ON ALL TABLES IN SCHEMA <schemaname> TO  <dbname>_ro;
resource "postgresql_grant" "table_privileges_ro_user" {
  database    = local.database_name
  role        = local.my_map["ro_user"]
  schema      = local.schema_name
  object_type = "table" 
  objects     = [] 
  privileges  = ["SELECT"]

  depends_on = [
    postgresql_schema.schema_application
  ]
}


#GRANT SELECT ON ALL SEQUENCES IN SCHEMA <schemaname> TO <dbname>_ro;
resource "postgresql_grant" "sequence_privileges_ro_user" {
  database    = local.database_name
  role        = local.my_map["ro_user"]
  schema      = local.schema_name
  object_type = "sequence" 
  objects     = [] 
  privileges  = ["SELECT"]

  depends_on = [
    postgresql_schema.schema_application
  ]
}


#ALTER DEFAULT PRIVILEGES FOR ROLE <dbname>_service IN SCHEMA <schemaname> GRANT SELECT  ON TABLES TO <dbname>_ro;

resource "postgresql_default_privileges" "table_default_privileges_ro_user" {
  //role     = local.my_map["ro_user"]
  role     = local.my_map["ro_user"]
  database = local.database_name
  schema   = local.schema_name
  owner       = local.my_map["mig_user"]
  object_type = "table"
  privileges  = ["SELECT"]

  depends_on = [
    postgresql_schema.schema_application
  ]
}

#ALTER DEFAULT PRIVILEGES FOR ROLE <dbname>_service IN SCHEMA <schemaname> GRANT USAGE,SELECT ON SEQUENCES TO <dbname>_service;
resource "postgresql_default_privileges" "sequence_default_privileges_ro_user" {
  role     = local.my_map["ro_user"]
  database = local.database_name
  schema   = local.schema_name
  owner       = local.my_map["mig_user"]
  object_type = "sequence"
  privileges  = ["SELECT"]

  depends_on = [
    postgresql_schema.schema_application
  ]
}







