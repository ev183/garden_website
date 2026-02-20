variable "create_security_group" {
  description = "Whether to create a new security group or use an existing one"
  type        = bool
  default     = false
}

variable "security_group_ids" {
  description = "List of security group IDs (required if create_security_group = false)"
  type        = list(string)
  default     = []  # ← This makes it optional
}

variable "vpc_id" {
  description = "VPC ID (required if create_security_group = true)"
  type        = string
  default     = null  # ← This makes it optional
}

variable "alb_name" {
  description = "Name of the ALB"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ALB"
  type        = list(string)
}

# modules/alb/variables.tf

variable "certificate_arn" {
  description = "ARN of ACM certificate for HTTPS"
  type        = string
  default     = null
}

variable "enable_https" {
  description = "Enable HTTPS listener"
  type        = bool
  default     = false
}