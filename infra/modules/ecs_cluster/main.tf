# Creates the ecs cluster
resource "aws_ecs_cluster" "this" {
  name = var.cluster_name
}

# Associate Fargate capacity providers with the cluster
resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name = aws_ecs_cluster.this.name

  capacity_providers = [
    "FARGATE",
    "FARGATE_SPOT"
  ]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
  }
}

# Create an IAM role for ECS task execution with necessary permissions
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

# Attach the AmazonECSTaskExecutionRolePolicy to the IAM role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Define the task definition for the ECS cluster
resource "aws_ecs_task_definition" "my_task" {
  family                   = var.ecs_task_definition_family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu    = "256"
  memory = "512"


  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn       = aws_iam_role.ecs_task_execution_role.arn

# Define the container image to use for the task
  container_definitions = jsonencode([
    {
      name      = "my-app"
      image     = "990991767208.dkr.ecr.us-east-1.amazonaws.com/garden-website-repo:latest"
      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "web_service" {
  name            = "web-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.my_task.arn
  desired_count   = 3
  iam_role        = aws_iam_role.ecs_task_execution_role.arn
  depends_on      = [aws_iam_role_policy_attachment.ecs_task_execution_role_policy]

  network_configuration {
    subnets = module.vpc.subnet_ids
  }
}




