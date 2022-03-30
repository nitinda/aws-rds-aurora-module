variable "prefix" {
  description = "Creates a unique name beginning with the specified prefix"
  type        = string
  default     = "ohmp"
}

variable "cluster_timeouts" {
  description = "Create, update, and delete timeout configurations for the cluster"
  type        = map(string)
  default = {
    create = "120m"
    update = "120m"
    delete = "130m"
  }
}

variable "allow_major_version_upgrade" {
  description = "Enable to allow major engine version upgrades when changing engine versions"
  type        = bool
  default     = false
}

variable "apply_immediately" {
  description = "Determines whether or not any DB modifications are applied immediately, or during the maintenance window"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "The days to retain backups for. Default 1"
  default     = 1
}

variable "cluster_identifier_prefix" {
  description = "Creates a unique cluster identifier beginning with the specified prefix"
  type        = string
  default     = null
}

variable "cluster_identifier" {
  description = "Creates a unique cluster identifier beginning with the specified prefix"
  type        = string
  default     = null
}

variable "copy_tags_to_snapshot" {
  description = "Copy all Cluster tags to snapshots."
  type        = bool
  default     = false
}

variable "database_name" {
  description = "Name for an automatically created database on cluster creation."
  type        = string
  default     = null
}

variable "db_cluster_parameter_group_name" {
  description = "A cluster parameter group to associate with the cluster."
  type        = string
  default     = null
}

variable "db_cluster_subnet_group_name" {
  description = "A DB subnet group to associate with this DB instance"
  type        = string
  default     = null
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to cloudwatch"
  type        = list(string)
  default     = []
}

variable "engine" {
  description = "The name of the database engine to be used for this DB cluster."
  type        = string
  default     = "aurora"
}

variable "engine_mode" {
  description = "The database engine mode."
  type        = string
  default     = "provisioned"
}

variable "engine_version" {
  description = "The database engine version"
  type        = string
  default     = null
}

variable "iam_database_authentication_enabled" {
  description = "Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled."
  type        = bool
  default     = null
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key."
  type        = string
  default     = null
}

variable "master_username" {
  description = "Username for the master DB user"
  type        = string
}

variable "master_password" {
  description = "Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file"
  type        = string
}

variable "port" {
  description = "The port on which the DB accepts connections"
  type        = number
  default     = null
}

variable "scaling_configuration" {
  description = "Nested attribute with scaling properties."
  type        = any
  default     = {}
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB cluster is deleted."
  default     = false
  type        = bool
}

variable "storage_encrypted" {
  description = "Specifies whether the DB cluster is encrypted"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Resources Tags"
  type        = map(string)
  default     = {}
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate with the Cluster"
  type        = list(string)
  default     = []
}



####### RDS Parameter Group

variable "rds_cluster_parameter_group_name" {
  description = "The name of the DB cluster parameter group."
  default     = null
  type        = string
}

variable "rds_cluster_parameter_group_name_prefix" {
  description = "Creates a unique name beginning with the specified prefix."
  default     = null
  type        = string
}

variable "rds_cluster_parameter_group_description" {
  description = "The description of the DB subnet group."
  default     = null
  type        = string
}

variable "rds_cluster_parameter_group_family" {
  description = "The family of the DB cluster parameter group."
  default     = null
  type        = string
}

variable "rds_cluster_parameter_group_parameter" {
  description = "A list of DB parameters to apply."
  type        = any
  default     = {}
}


####### DB Subnet Group
variable "db_subnet_group_name" {
  description = "The name of the DB subnet group."
  type        = string
  default     = null
}

variable "db_subnet_group_name_prefix" {
  description = "Creates a unique name beginning with the specified prefix."
  type        = string
  default     = null
}

variable "db_subnet_group_description" {
  description = "The description of the DB subnet group."
  type        = string
  default     = null
}

variable "db_subnet_group_subnet_ids" {
  description = "A list of VPC subnet IDs."
  type        = list(string)
  default     = []
}
