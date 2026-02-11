output "task_definition_arn" {
  description = "ARN of the ECS task definition"
  value       = aws_ecs_task_definition.this.arn
}

output "family" {
  description = "Task definition family name"
  value       = aws_ecs_task_definition.this.family
}
