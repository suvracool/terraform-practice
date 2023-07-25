resource "random_password" "password_application" {
  for_each  = toset(local.user_names) 
  length           = 32
  min_upper        = 3
  min_lower        = 3
  min_numeric      = 3
  min_special      = 3
  special          = true
  override_special = "!#$*()[]{}<>:?"
}
