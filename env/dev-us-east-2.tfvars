# default AWS Tags
default_aws_tags = {
  Terraform = "true"
  Environment = "dev"
}

db = {
  identifier = "ami-dev-mysql-aurora"
  name = "amidevmysqlaurora"
  engine = "aurora-mysql"
  engine_version = "5.7.12"

  instance_class = "db.t3.small"

  storage_encrypted_at_rest = false

  username = "ami_db_admin"
  port = "3306"

  #Sunday Night
  maintenance_window = "Mon:00:00-Mon:03:00"

  backup_window = "03:00-06:00"

  backup_retention_period = 1

  replica_count = 1
}