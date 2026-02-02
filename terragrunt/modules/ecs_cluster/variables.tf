variable "cluster_name" {
  type        = string
  description = "Name of the ECS cluster"
}

variable "ecs_task_definition_family" {
  type        = string
  description = "Family name for the ECS task definition"
}