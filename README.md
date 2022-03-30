# _Terraform Module : aws-rds-aurora-module_
_Terraform Module for_ **_RDS Cluster Module_**

---

## _General_

_This module may be used to create_ **_RDS Cluster Module_** _resources in AWS cloud provider......_

---


## _Prerequisites_

_This module needs_ **_Terraform 1.1.5_** _or newer._
_You can download the latest Terraform version from_ [here](https://www.terraform.io/downloads.html).

_This module deploys aws services details are in respective feature branches._

---

## _Features_

_Below we are able to check the resources that are being created as part of this module call:_

- [ ] **_RDS Cluster_**
- [ ] **_RDS Cluster Parameter Group_**
- [ ] **_DB Subnet Group_**


---


## _Usage_

## _Using this repo_

_To use this module, add the following call to your code:_

### MYSQL RDS

```tf

resource "random_password" "password_mysql_rds" {
  length  = 25
  special = false
  # override_special = "_%@"
}

resource "aws_security_group" "security_group_mysql_rds" {
  name_prefix = "mysql-rds-sg-"
  description = "MYSQL RDS Security Group"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow RDS port traffic from EC2"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["100.91.0.0/26", "100.91.0.64/26"]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "mysql-rds-sg"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

module "mysql_rds_cluster" {
  source = "git::https://github.com/nitinda/aws-rds-aurora-module.git?ref=main"

  prefix                          = "mysql"
  apply_immediately               = true
  cluster_identifier              = "mysql-rds"
  engine                          = "aurora-mysql"
  engine_version                  = "5.7.mysql_aurora.2.07.1"
  engine_mode                     = "serverless"
  copy_tags_to_snapshot           = true
  database_name                   = "mysql"
  master_username                 = "mysql"
  master_password                 = random_password.password_mysql_rds.result
  backup_retention_period         = 1
  vpc_security_group_ids          = [aws_security_group.security_group_mysql_rds.id]
  skip_final_snapshot             = true
  // enabled_cloudwatch_logs_exports = ["error"]

  rds_cluster_parameter_group_name        = "mysql-aruora-mysql5-7"
  rds_cluster_parameter_group_description = "MYSQL cluster parameter group for aurora-mysql5.7"
  rds_cluster_parameter_group_family      = "aurora-mysql5.7"

  db_subnet_group_name       = "mysql-db-subnets"
  db_subnet_group_subnet_ids = ["subnet-0e7282f7391c3c379", "subnet-03984e0e591f870c6"]

  scaling_configuration = {
    auto_pause               = true
    max_capacity             = 4
    min_capacity             = 1
    seconds_until_auto_pause = 300
    timeout_action           = "RollbackCapacityChange"
  }

  tags = merge(
    {
      Application    = "ecs"
      ApplicationSub = "ecs"
      PII            = "false"
      Backup         = "n/a"
    },
    {
      Name = "mysql-rds-cluster"
    }
  )
}

```

### PostgreSQL RDS

```tf

resource "random_password" "password_postgresql_rds" {
  length  = 25
  special = false
  # override_special = "_%@"
}

resource "aws_security_group" "security_group_postgresql_rds" {
  name_prefix = "postgresql-rds-sg-"
  description = "PostgreSQL RDS Security Group"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow RDS port traffic from EC2"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["100.91.0.0/26", "100.91.0.64/26"]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "mysql-rds-sg"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

module "postgresql_rds_cluster" {
  source = "git::https://github.com/nitinda/aws-rds-aurora-module.git?ref=main"

  prefix                          = "postgresql"
  apply_immediately               = true
  cluster_identifier              = "postgresql-rds"
  engine                          = "aurora-postgresql"
  engine_version                  = "10.14"
  engine_mode                     = "serverless"
  copy_tags_to_snapshot           = true
  database_name                   = "postgresql"
  master_username                 = "postgresql"
  master_password                 = random_password.password_postgresql_rds.result
  backup_retention_period         = 1
  vpc_security_group_ids          = [aws_security_group.security_group_postgresql_rds.id]
  skip_final_snapshot             = true
  port                            = 5432
  // enabled_cloudwatch_logs_exports = ["error"]

  rds_cluster_parameter_group_name        = "postgresql-aurora-postgresql10"
  rds_cluster_parameter_group_family      = "aurora-postgresql10"
  rds_cluster_parameter_group_description = "PostgreSQL cluster parameter group for aurora-postgresql10"

  db_subnet_group_name       = "postgresql-db-subnets"
  db_subnet_group_subnet_ids = ["subnet-0e7282f7391c3c379", "subnet-03984e0e591f870c6"]

  scaling_configuration = {
    auto_pause               = true
    max_capacity             = 32
    min_capacity             = 2
    seconds_until_auto_pause = 300
    timeout_action           = "RollbackCapacityChange"
  }

  tags = merge(
    {
      Application    = "ecs"
      ApplicationSub = "ecs"
      Backup         = "n/a"
    },
    {
      Name = "postgresql-rds-cluster"
    }
  )
}

```


---

## _Inputs_

_The variables required in order for the module to be successfully called from the deployment repository are the following:_


|**_Variable_** | **_Description_** | **_Type_** | **_Argument Status_** | **_Default Value_** |
|:----|:----|-----:|-----:|-----:|
| **_prefix_** | _Creates a unique name beginning with the specified prefix for all resources_ | _string_ | **_Optional_** | **_ohmp_** |
| **_allow\_major\_version\_upgrade_** | _Enable to allow major engine version upgrades when changing engine versions_ | _bool_ | **_Optional_** | **_false_** |
| **_apply\_immediately_** | _Determines whether or not any DB modifications are applied immediately, or during the maintenance window_ | _bool_ | **_Optional_** | **_false_** |
| **_backup\_retention\_period_** | _The days to retain backups for. Default 1_ | _number_ | **_Optional_** | **_1_** |
| **_tags_** | _A mapping of tags to assign to the launch template_ | _map(string)_ | **_Optional_** | **_{}_** |
| **_cluster\_identifier\_prefix_** | _Creates a unique cluster identifier beginning with the specified prefix_ | _string_ | **_Optional_** | **_null_** |
| **_cluster\_identifier_** | _Creates a unique cluster identifier beginning with the specified prefix_ | _string_ | **_Optional_** | **_null_** |
| **_copy\_tags\_to\_snapshot_** | _Copy all Cluster tags to snapshots._ | _bool_ | **_Optional_** | **_false_** |
| **_database\_name_** | _"Name for an automatically created database on cluster creation._ | _string_ | **_Optional_** | **_null_** |
| **_db\_cluster\_parameter\_group\_name_** | _"A cluster parameter group to associate with the cluster. Use existing group._ | _string_ | **_Optional_** | **_null_** |
| **_db\_cluster\_subnet\_group\_name_** | _"A DB subnet group to associate with this DB instance. Use existing group._ | _string_ | **_Optional_** | **_null_** |
| **_enabled\_cloudwatch\_logs\_exports_** | _List of log types to export to cloudwatch_ | _list(string)_ | **_Optional_** | **_[]_** |
| **_engine_** | _The name of the database engine to be used for this DB cluster._ | _string_ | **_Optional_** | **_aurora_** |
| **_engine\_mode_** | _The database engine mode._ | _string_ | **_Optional_** | **_provisioned_** |
| **_iam\_database\_authentication\_enabled_** | _Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled._ | _bool_ | **_Optional_** | **_null_** |
| **_kms\_key\_id_** | _The ARN for the KMS encryption key._ | _string_ | **_Optional_** | **_null_** |
| **_master\_username_** | _Username for the master DB user_ | _string_ | **_Required_** |
| **_master\_password_** | _Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file_ | _string_ | **_Required_** |
| **_port_** | _The port on which the DB accepts connections._ | _number_ | **_Optional_** | **_null_** |
| **_scaling\_configuration_** | _Nested attribute with scaling properties._ | _any_ | **_Optional_** | **_{}_** |
| **_skip\_final\_snapshot_** | _Determines whether a final DB snapshot is created before the DB cluster is deleted._ | _bool_ | **_Optional_** | **_false_** |
| **_storage\_encrypted_** | _Specifies whether the DB cluster is encrypted._ | _bool_ | **_Optional_** | **_false_** |
| **_vpc\_security\_group\_ids_** | _List of VPC security groups to associate with the Cluster._ | _list(string)_ | **_Optional_** | **_[]_** |
| **_rds\_cluster\_parameter\_group\_name_** | _The name of the DB cluster parameter group._ | _string_ | **_Optional_** | **_null_** |
| **_rds\_cluster\_parameter\_group\_name\_prefix_** | _Creates a unique name beginning with the specified prefix._ | _string_ | **_Optional_** | **_null_** |
| **_rds\_cluster\_parameter\_group\_description_** | _The description of the DB subnet group._ | _string_ | **_Optional_** | **_null_** |
| **_rds\_cluster\_parameter\_group\_family_** | _The family of the DB cluster parameter group._ | _string_ | **_Optional_** | **_null_** |
| **_rds\_cluster\_parameter\_group\_parameter_** | _A list of DB parameters to apply._ | _any_ | **_Optional_** | **_{}_** |
| **_db\_subnet\_group\_name_** | _The name of the DB subnet group._ | _string_ | **_Optional_** | **_null_** |
| **_db\_subnet\_group\_name\_prefix_** | _Creates a unique name beginning with the specified prefix._ | _string_ | **_Optional_** | **_null_** |
| **_db\_subnet\_group\_description_** | _The description of the DB subnet group._ | _string_ | **_Optional_** | **_null_** |
| **_db\_subnet\_group\_subnet\_ids_** | _A list of VPC subnet IDs._ | _list(string)_ | **_Optional_** | **_[]_** |

---

## _Outputs_

### _General_

_This module has the following outputs:_

* **_N/A_**

---


### _Usage_

_In order for the variables to be accessed on module level please use the syntax below:_

```tf
module.<module_name>.<output_variable_name>
```

_The output variable is able to be accessed through terraform state file using the syntax below:_

```tf
data.terraform_remote_state.<module_name>.<output_variable_name>
```

---

## _Authors_

_Module maintained by Module maintained by the - [Nitin Das]_
