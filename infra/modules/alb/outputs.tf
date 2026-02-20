output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.main.arn
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.alb.dns_name
}

output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.alb.arn
}

output "listener_arn" {
  description = "ARN of the HTTP listener"
  value       = aws_lb_listener.http.arn
}






# modules/alb/outputs.tf

output "alb_id" {
  description = "The ID of the load balancer"
  value       = aws_lb.alb.id
}


output "alb_zone_id" {
  description = "The zone ID of the load balancer"
  value       = aws_lb.alb.zone_id
}

output "security_group_id" {
  description = "ID of the ALB security group"
  value       = var.create_security_group ? aws_security_group.alb_sg[0].id : null
}

output "http_listener_arn" {
  description = "ARN of the HTTP listener"
  value       = aws_lb_listener.http.arn
}

output "https_listener_arn" {
  description = "ARN of the HTTPS listener (if enabled)"
  value       = var.enable_https ? aws_lb_listener.https[0].arn : null
}