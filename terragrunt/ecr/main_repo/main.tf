module "ecr_repo" {
  source = "../module"
  name   = local.repo_name
}