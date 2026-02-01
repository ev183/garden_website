module "ecr_repo" {
  source = "../modules/ecr"
  name   = local.repo_name
}