resource "aws_rds_cluster" "rds_cluster" {
  engine                              = var.engine
  engine_mode                         = var.engine_mode
  engine_version                      = var.engine_version
  database_name                       = var.database_name
  cluster_identifier_prefix           = var.cluster_identifier_prefix
  cluster_identifier                  = var.cluster_identifier
  master_username                     = var.master_username
  master_password                     = var.master_password
  storage_encrypted                   = var.engine_mode == "serverless" ? true : var.storage_encrypted
  skip_final_snapshot                 = var.skip_final_snapshot
  backup_retention_period             = var.backup_retention_period
  port                                = var.port
  apply_immediately                   = var.apply_immediately
  db_subnet_group_name                = local.rds_cluster_db_subnet_group_name
  db_cluster_parameter_group_name     = local.rds_cluster_db_parameter_group_name
  vpc_security_group_ids              = var.vpc_security_group_ids
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  kms_key_id                          = var.kms_key_id
  enabled_cloudwatch_logs_exports     = var.enabled_cloudwatch_logs_exports
  copy_tags_to_snapshot               = var.copy_tags_to_snapshot

  dynamic "scaling_configuration" {
    for_each = var.scaling_configuration == {} ? [] : [var.scaling_configuration]
    content {
      auto_pause               = lookup(scaling_configuration.value, "auto_pause", null)
      max_capacity             = lookup(scaling_configuration.value, "max_capacity", null)
      min_capacity             = lookup(scaling_configuration.value, "min_capacity", null)
      seconds_until_auto_pause = lookup(scaling_configuration.value, "seconds_until_auto_pause", null)
      timeout_action           = lookup(scaling_configuration.value, "timeout_action", null)
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-rds"
    }
  )

  lifecycle {
    create_before_destroy = true
  }

  timeouts {
    create = lookup(var.cluster_timeouts, "create", null)
    update = lookup(var.cluster_timeouts, "update", null)
    delete = lookup(var.cluster_timeouts, "delete", null)
  }
}
