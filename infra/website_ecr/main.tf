# Use the ECR module to create the ECR repository for the website container image
module "ecr_repo" {
  source = "../modules/ecr"
  name   = local.repo_name
}

# Specify the ALB configuration in a local variable, which will be passed to the ALB module
locals {
  repo_name = "garden-website-repo"
}