resource "aws_db_subnet_group" "db_subnet_group" {
  count       = var.db_subnet_group_name == null && var.db_subnet_group_name_prefix == null && var.rds_cluster_db_subnet_group_name == null ? 0 : 1
  name        = var.db_subnet_group_name
  name_prefix = var.db_subnet_group_name_prefix
  description = var.db_subnet_group_description
  subnet_ids  = var.db_subnet_group_subnet_ids
  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-db-subnet-group"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  rds_cluster_db_subnet_group_name = var.rds_cluster_db_subnet_group_name == null ? join("", aws_db_subnet_group.db_subnet_group.*.name) : var.rds_cluster_db_subnet_group_name
}
