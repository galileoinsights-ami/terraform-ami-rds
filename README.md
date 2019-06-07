# Setting up AMI Databases with Terraform

This is used to create all the RDS instance required by AMI. Presently, this module creates the following:

* MySQL 5.7 Instance
* DB Parameter Group
* DB Options Group

Sizing, Multi-Region Availability, backup, update options can be provided using TFVAR files in the `env` folder

## Pre Requisites

1. **Pre-Commit Git Hook**: Install `pre-commit`. Visit https://pre-commit.com/. This is used to clean up the code before commiting to git.
2. **AWS Secret Scanner**: Install git-secrets. Visit https://github.com/awslabs/git-secrets. This is used to scan for aws credentials before a commit occurs.
3. **Terraform**: v0.11 Installed
4. **Execute AMI-Network**: Run [AMI-Network Terraform module](https://github.com/galileoinsights-ami/terraform-ami-network)
5. Have a `setup.sh` file which exports all the environment varibles mentioned below in the root directory of this workspace

## Setup Environment Variable

Following Environment Variables need to be setup.

Variable Name | Description | Required? | Example Values
---|---|---|---
ENV | The environment of this AWS Setup | Yes | dev, prod
AWS_ACCESS_KEY_ID | AWS Access key of user `TFNetwork` | Yes |
AWS_SECRET_ACCESS_KEY | AWS Access Secret Key of user `TFNetwork` | Yes |
AWS_DEFAULT_REGION | The AWS Region to work with | Yes | us-east-2
TF_VAR_backend_s3_bucket_name | The S3 Terraform Backend Bucket | Yes | ami-terraform-configs
TF_VAR_db_password | The Password for the DB Admin | Yes |

## Before Committing

1. Scan for Secrets in to be committed files

```
git secrets --scan -r
git secrets --scan --cached --no-index --untracked
```

## Executing Terraform

Execute `deploy.sh` file

```
export ENV="dev";./deploy.sh
```