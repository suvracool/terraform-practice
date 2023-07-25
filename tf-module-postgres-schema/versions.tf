terraform {
  required_version = ">= 0.13.0"

  required_providers {
    random = ">=3.0.0"
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = ">= 1.7.2"
    }
  }
}
