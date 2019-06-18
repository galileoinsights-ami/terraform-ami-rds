# Backend Initialization using command line

terraform {
 backend "s3" {
   key = "rds.tfstate"
 }
}

locals {

}

# Initializing the provider

# Following properties need to be set for this to work
# export AWS_ACCESS_KEY_ID="anaccesskey"
# export AWS_SECRET_ACCESS_KEY="asecretkey"
# export AWS_DEFAULT_REGION="us-west-2"
# terraform plan
provider "aws" {}


data "terraform_remote_state" "network" {
  backend = "s3"
  config {
    key = "network.tfstate"
    bucket = "${var.backend_s3_bucket_name}"
  }
}


resource "aws_db_parameter_group" "aurora_db_57_parameter_group" {
  name        = "ami-aurora-db-57-parameter-group"
  family      = "aurora-mysql5.7"
  description = "AMI Aurora DB 5.7 Parameter Group"
}

resource "aws_rds_cluster_parameter_group" "aurora_57_cluster_parameter_group" {
  name        = "ami-aurora-57-cluster-parameter-group"
  family      = "aurora-mysql5.7"
  description = "AMI Aurora DB 5.7 Cluster Parameter Group"
}

module "db" {
  source                          = "terraform-aws-modules/rds-aurora/aws"
  version                         = "~> 1.14"

  # All available versions: http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_MySQL.html#MySQL.Concepts.VersionMgmt
  engine                          = "${var.db["engine"]}"
  engine_version                  = "${var.db["engine_version"]}"
  db_parameter_group_name         = "${aws_db_parameter_group.aurora_db_57_parameter_group.id}"
  db_cluster_parameter_group_name = "${aws_rds_cluster_parameter_group.aurora_57_cluster_parameter_group.id}"

  instance_type                  = "${var.db["instance_class"]}"
  storage_encrypted               = "${var.db["storage_encrypted_at_rest"]}"

  #Cluster Settings
  replica_count                   = "${var.db["replica_count"]}"

  name                            = "${var.db["name"]}"
  username                        = "${var.db["username"]}"
  password                        = "${var.db_password}"
  port                            = "${var.db["port"]}"

  vpc_security_group_ids          = ["${data.terraform_remote_state.network.default_security_group_id}"]

  preferred_maintenance_window    = "${var.db["maintenance_window"]}"
  preferred_backup_window         = "${var.db["backup_window"]}"


  backup_retention_period         = "${var.db["backup_retention_period"]}"

  enabled_cloudwatch_logs_exports = ["audit", "general"]

  apply_immediately               = true

  # DB Networking
  vpc_id                          = "${data.terraform_remote_state.network.vpc_id}"
  subnets                         = ["${data.terraform_remote_state.network.database_subnets}"]

  # Snapshot name upon DB deletion
  final_snapshot_identifier_prefix       = "${var.db["identifier"]}"

  # Database Deletion Protection
  deletion_protection             = true

  #Cloud Watch
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  tags                             = "${var.default_aws_tags}"
}
