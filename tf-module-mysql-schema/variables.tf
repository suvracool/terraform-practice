variable "database_name" {
  description = "The database name."
  type        = string
  default     = null
}

variable "schema_name" {
  description = "The schema name."
  type        = string
  default     = null
}

variable "mysql_host" {
  description = "mysql host "
  type = string 
  default = null 
}

variable "private_subnet_cdirs_list"{
  type = map(list(string))
  default = {
    dev  = ["10.32.0.0/16", "10.16.0.0/16", "100.64.0.0/16"]
    stg  = ["10.24.0.0/16", "10.16.0.0/16", "100.64.0.0/16"]
    prod = ["10.16.0.0/16", "100.64.0.0/16"]
  }
}
