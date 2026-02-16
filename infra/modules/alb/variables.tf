variable "alb_name" {
  type = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ALB"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to the ALB"
  type        = list(string)
}