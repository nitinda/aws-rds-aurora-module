output "endpoint" {
  description = "The DNS address of the RDS instance"
  value       = aws_rds_cluster.rds_cluster.endpoint
}

output "id" {
  description = "The RDS Cluster Identifier"
  value       = aws_rds_cluster.rds_cluster.id
}

output "arn" {
  description = "Amazon Resource Name (ARN) of cluster"
  value       = aws_rds_cluster.rds_cluster.arn
}

output "database_name" {
  description = "The database name"
  value       = aws_rds_cluster.rds_cluster.database_name
}

output "port" {
  description = "The database port"
  value       = aws_rds_cluster.rds_cluster.database_name
}

output "engine" {
  description = "The database engine"
  value       = aws_rds_cluster.rds_cluster.engine
}

output "master_username" {
  description = "The master username for the database"
  value       = aws_rds_cluster.rds_cluster.master_username
}
