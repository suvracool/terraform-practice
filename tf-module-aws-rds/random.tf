resource "random_password" "password" {
  count = local.create_rds ? 1 : 0
  length           = 32
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  special          = true
  override_special = "!#$*()[]{}<>:?"
}
