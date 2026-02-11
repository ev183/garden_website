variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "capacity_providers" {
  description = "Optional list of ECS capacity providers (e.g., FARGATE, FARGATE_SPOT)"
  type        = list(string)
  default     = ["FARGATE"]
}

variable "default_capacity_provider_strategy" {
  description = "Optional default capacity provider strategy"
  type = list(object({
    capacity_provider = string
    weight            = optional(number)
    base              = optional(number)
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to the ECS cluster"
  type        = map(string)
  default     = {}
}
