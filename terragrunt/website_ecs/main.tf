module "ecs_cluster" {
  source = "../modules/ecs_cluster"
  cluster_name = local.name
}