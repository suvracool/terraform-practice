locals {
    docdb_full_name                         = lower(var.docdb_full_name) /*To be fetched from cookiecutter*/
    password                                = random_password.password.0.result
    aws_db_subnet_group                     = lookup(var.db_subnet_group_name, terraform.workspace)
    cluster_number                          = lookup(var.cluster_size,terraform.workspace)
    instance_class                          = lookup(var.instance_class,terraform.workspace)
    enable_performance_insights             = lookup(var.enable_performance_insights,terraform.workspace)


    local_tags = {
    Name        = local.docdb_full_name
    module_name = "aws-docdb"
  }

  tags = merge(
    var.tags,
    local.local_tags
  )

  all_tags_lower = { for k, v in local.tags : k => lower(v) }                       
}
