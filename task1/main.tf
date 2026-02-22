module "globals" {
  source = "../modules/globals"

  project_prefix = "dcesanelli-task1"
  project        = "Daniel DevOps Challenge Task1"
}

module "networking" {
  source = "../modules/networking"

  availability_zones     = var.availability_zones
  vpc_cidr               = var.vpc_cidr
  public_subnets_cidrs   = var.public_subnets_cidrs
  private_subnets_cidrs  = var.private_subnets_cidrs
  database_subnets_cidrs = var.database_subnets_cidrs

  globals = module.globals
}

module "compute" {
  source = "../modules/compute"

  vpc_id         = module.networking.vpc_id
  subnet_id      = module.networking.public_subnets[0]
  ami_id         = var.ami_id
  instance_type  = var.instance_type
  instance_sg_id = module.networking.instance_sg_id
  db_secret_arn  = module.database.db_secret_arn

  globals = module.globals
}

module "database" {
  source = "../modules/database"

  vpc_id               = module.networking.vpc_id
  db_sg_id             = module.networking.db_sg_id
  db_subnet_group_name = module.networking.database_subnet_group_name
  db_instance_class    = var.db_instance_class

  globals = module.globals
}
