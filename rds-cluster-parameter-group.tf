resource "aws_rds_cluster_parameter_group" "rds_cluster_parameter_group" {
  count       = var.rds_cluster_parameter_group_name == null && var.rds_cluster_parameter_group_name_prefix == null && var.rds_cluster_db_parameter_group_name == null ? 0 : 1
  name        = var.rds_cluster_parameter_group_name
  name_prefix = var.rds_cluster_parameter_group_name_prefix
  family      = var.rds_cluster_parameter_group_family
  description = var.rds_cluster_parameter_group_description

  dynamic "parameter" {
    for_each = var.rds_cluster_parameter_group_parameter
    content {
      apply_method = lookup(parameter.value, "apply_method", null)
      name         = parameter.value.name
      value        = parameter.value.value
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-rds-cluster-parameter-group"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  rds_cluster_db_parameter_group_name = var.rds_cluster_db_parameter_group_name == null ? join("", aws_rds_cluster_parameter_group.rds_cluster_parameter_group.*.name) : var.rds_cluster_db_parameter_group_name
}
