locals {
  schema_name   = format("%s_service", replace(var.schema_name == null ? var.database_name : var.schema_name, "-", "_"))
  database_name = format("%s_service", replace(var.database_name, "-", "_"))

  user_map ={
    mig_user = format("%s_service", replace(var.database_name, "-", "_"))
    app_user = format("%s_application", replace(var.database_name, "-", "_"))
    ro_user  = format("%s_ro", replace(var.database_name, "-", "_"))
  }
}
