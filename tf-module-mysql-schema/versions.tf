terraform {
  required_version = ">= 0.13.0"

  required_providers {
    random = ">=3.0.0"
    mysql = {
      source = "winebarrel/mysql"
      version = "1.10.6"
      }
  }
}



