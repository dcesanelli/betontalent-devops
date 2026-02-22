module "globals" {
  source = "../modules/globals"

  project_prefix = "dcesanelli-task2"
  project        = "Daniel DevOps Challenge Task2"
}

module "networking" {
  source = "../modules/networking"

  globals = module.globals
}

module "security" {
  source = "../modules/security"

  globals = module.globals
}

module "compute" {
  source = "../modules/compute"

  vpc_id               = module.networking.vpc_id
  subnet_id            = module.networking.private_subnets[0]
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  instance_sg_id       = module.networking.instance_sg_id
  kms_key_arn          = module.security.kms_key_arn
  create_secret_policy = false
  is_public            = false

  globals = module.globals
}
