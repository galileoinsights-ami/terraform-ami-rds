variable "default_aws_tags" {
  description = "default aws tags"
  default = {}
}

variable "backend_s3_bucket_name" {
  description = "S3 bucket which contains remote state"
}

variable "db" {
  default = {}
  description = "All the DB Properties"
}

# The below should be passed using the environment variable TF_VAR_db_password
variable "db_password" {
  description = "The password to be used of the DB Administrator."
}