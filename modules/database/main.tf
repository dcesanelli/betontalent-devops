# Create an RDS PostgreSQL instance
module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 7.1"

  identifier = "${var.globals.name_prefix}-postgres"

  engine               = "postgres"
  engine_version       = var.engine_version
  family               = var.family
  major_engine_version = var.major_engine_version
  instance_class       = var.db_instance_class

  allocated_storage = 20
  db_name           = var.db_name
  username          = var.db_username
  port              = 5432

  # Let RDS manage the master user password and store it in Secrets Manager
  manage_master_user_password = true

  vpc_security_group_ids = [var.db_sg_id]
  db_subnet_group_name   = var.db_subnet_group_name

  skip_final_snapshot = true

  tags = merge(var.globals.global_tags, {
    Name = "Database Instance"
  })
}

