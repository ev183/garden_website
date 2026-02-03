module "ecs_cluster" {
  source = "../modules/ecs_cluster"
  
  cluster_name = local.name
  ecs_task_definition_family = local.ecs_task_definition_family
}

locals {
  name = "garden-website-cluster"
  ecs_task_definition_family = "garden-website-task-family"
}
