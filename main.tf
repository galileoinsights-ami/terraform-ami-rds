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

module "db" {
  source = "terraform-aws-modules/rds/aws"
  version = "1.28.0"

  identifier = "${var.db["identifier"]}"

  # All available versions: http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_MySQL.html#MySQL.Concepts.VersionMgmt
  engine            = "${var.db["engine"]}"
  engine_version    = "${var.db["engine_version"]}"

  # DB parameter group
  family = "${var.db["family"]}"
  # DB option group
  major_engine_version = "${var.db["major_engine_version"]}"

  instance_class    = "${var.db["instance_class"]}"
  allocated_storage = "${var.db["allocated_storage"]}"
  storage_encrypted = "${var.db["storage_encrypted_at_rest"]}"
  storage_type = "${var.db["storage_type"]}"

  # kms_key_id        = "arm:aws:kms:<region>:<accound id>:key/<kms key id>"
  name     = "${var.db["name"]}"
  username = "${var.db["username"]}"
  password = "${var.db_password}"
  port     = "${var.db["port"]}"

  vpc_security_group_ids = ["${data.terraform_remote_state.network.default_security_group_id}"]

  maintenance_window = "${var.db["maintenance_window"]}"
  backup_window      = "${var.db["backup_window"]}"

  multi_az = "${var.db["multi_az"]}"

  backup_retention_period = "${var.db["backup_retention_period"]}"

  enabled_cloudwatch_logs_exports = ["audit", "general"]

  # DB subnet group
  subnet_ids = ["${data.terraform_remote_state.network.database_subnets}"]
  db_subnet_group_name = "${data.terraform_remote_state.network.default_database_subnet_group}"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "${var.db["identifier"]}"

  # Database Deletion Protection
  deletion_protection = true

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]

  tags = "${var.default_aws_tags}"
}
