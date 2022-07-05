resource "aws_rds_cluster_instance" "rds_cluster_instance" {
  count              = var.engine_mode == "serverless" ? 0 : 2
  identifier         = var.rds_cluster_instance_identifier == null ? null : "${var.rds_cluster_instance_identifier}-${count.index}"
  identifier_prefix  = var.rds_cluster_instance_identifier_prefix == null ? null : "${var.rds_cluster_instance_identifier_prefix}-${count.index}"
  cluster_identifier = var.rds_cluster_instance_cluster_identifier == null ? aws_rds_cluster.rds_cluster.id : var.rds_cluster_instance_cluster_identifier
  instance_class     = var.rds_cluster_instance_instance_class
  engine             = aws_rds_cluster.rds_cluster.engine
  engine_version     = aws_rds_cluster.rds_cluster.engine_version
  #   publicly_accessible                   = var.rds_cluster_instance_publicly_accessible
    db_subnet_group_name                  = local.rds_cluster_db_subnet_group_name
    db_parameter_group_name               = local.rds_cluster_instance_db_parameter_group_name
  apply_immediately = aws_rds_cluster.rds_cluster.apply_immediately
  #   monitoring_role_arn                   = var.rds_cluster_instance_monitoring_role_arn
  #   monitoring_interval                   = var.rds_cluster_instance_monitoring_interval
  #   promotion_tier                        = var.rds_cluster_instance_promotion_tier
  availability_zone = data.aws_availability_zones.availability_zones.names[count.index]
  #   preferred_backup_window               = var.rds_cluster_instance_preferred_backup_window
  #   preferred_maintenance_window          = var.rds_cluster_instance_preferred_maintenance_window
  #   auto_minor_version_upgrade            = var.rds_cluster_instance_auto_minor_version_upgrade
  performance_insights_kms_key_id = var.rds_cluster_instance_performance_insights_kms_key_id
  # performance_insights_enabled          = var.rds_cluster_instance_performance_insights_enabled
  # performance_insights_retention_period = var.rds_cluster_instance_performance_insights_retention_period
  copy_tags_to_snapshot = aws_rds_cluster.rds_cluster.copy_tags_to_snapshot

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-rds-cluster-instance"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}
