variable "family" {
  description = "The family name of the task definition"
  type        = string
}

variable "container_definitions" {
  description = "JSON-encoded container definitions"
  type        = string
}

variable "cpu" {
  description = "CPU units for the task"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memory for the task (in MiB)"
  type        = number
  default     = 512
}

variable "execution_role_arn" {
  description = "IAM role ARN for ECS task execution"
  type        = string
}

variable "task_role_arn" {
  description = "IAM role ARN for the task itself"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the task definition"
  type        = map(string)
  default     = {}
}
