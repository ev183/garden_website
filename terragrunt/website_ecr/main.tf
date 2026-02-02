module "ecr_repo" {
  source = "../modules/ecr"
  name   = local.repo_name
}

locals {
  repo_name = "garden-website-repo"
}