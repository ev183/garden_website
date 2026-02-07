
variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "ecs_task_definition_family" {
  description = "Family name for the ECS task definition"
  type        = string
}