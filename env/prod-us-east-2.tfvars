# default AWS Tags
default_aws_tags = {
  Terraform = "true"
  Environment = "prod"
}

db = {
  identifier = "ami-prod-mysql"
  name = "amiprodmysql"
  engine = "mysql"
  engine_version = "5.7.23"

  # Decides the parameter group
  family = "mysql5.7"

  # Decides the options group
  major_engine_version = "5.7"
  instance_class = "db.t2.micro"

  # Amount of Storage in GB
  allocated_storage = "20"
  storage_encrypted_at_rest = false
  storage_type = "gp2"

  username = "ami_db_admin"
  port = "3306"

  #Sunday Night
  maintenance_window = "Mon:00:00-Mon:03:00"

  backup_window = "03:00-06:00"

  # the below must be true for production environments
  multi_az = true

  backup_retention_period = 7
}