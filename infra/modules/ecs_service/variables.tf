variable "service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "cluster_arn" {
  description = "ARN of the ECS cluster where the service will run"
  type        = string
}

variable "task_definition_arn" {
  description = "ARN of the task definition to run"
  type        = string
}

variable "desired_count" {
  description = "Number of tasks to run"
  type        = number
  default     = 1
}

variable "enable_load_balancer" {
  description = "Whether to attach the service to a load balancer"
  type        = bool
  default     = false
}



variable "target_group_arn" {
  description = "ARN of the target group"
  type        = string
  default     = null
}

variable "container_name" {
  description = "Name of the container to associate with the load balancer"
  type        = string
  default     = null
}

variable "container_port" {
  description = "Port on the container to associate with the load balancer"
  type        = number
  default     = null
}

variable "subnet_ids" {
  description = "List of subnet IDs for the service"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security groups to attach to the service ENIs"
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Whether to assign a public IP to the task ENI"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to the ECS service"
  type        = map(string)
  default     = {}
}
