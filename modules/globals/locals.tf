# Use locals to define common values and tags for the project. 
locals {
  environment = terraform.workspace == "default" ? "dev" : terraform.workspace

  name_prefix = "${var.project_prefix}-${local.environment}"

  global_tags = {
    "location"          = var.region
    "project"           = var.project
    "environment"       = local.environment
    "deployment-method" = "IaC"
  }
}
