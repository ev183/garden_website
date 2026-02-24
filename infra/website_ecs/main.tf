# Use the VPC module to create the VPC and subnets
module "vpc" {
  source = "../modules/vpc"

  vpc_name = local.vpc.vpc_name
  vpc_cidr = local.vpc.vpc_cidr
  subnets  = local.vpc.subnets
  tags     = local.vpc.tags
}

# Use the ecs_cluster module to create the ECS cluster
module "ecs_cluster" {
  source = "../modules/ecs_cluster"

  cluster_name = local.ecs_cluster.name
  tags         = local.ecs_cluster.tags
}

# Use the ecs_task module to create the ECS task definition
module "ecs_task" {
  source = "../modules/ecs_task"

  family                = local.ecs_task.family
  container_definitions = local.ecs_task.container_definitions
  cpu                   = local.ecs_task.cpu
  memory                = local.ecs_task.memory

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  tags = local.ecs_task.tags
}

# Reference the ALB target group to get its ARN for use in the ECS service
data "aws_lb_target_group" "alb" {
  name = "garden-website-alb-tg"
}

# Use the ecs_service module to create the ECS service and link it to the ALB target group
module "ecs_service" {
  source = "../modules/ecs_service"

  service_name        = local.ecs_service.name
  cluster_arn         = module.ecs_cluster.cluster_arn
  task_definition_arn = module.ecs_task.task_definition_arn

  subnet_ids          = module.vpc.private_subnet_ids  # ← Changed to private subnets
  security_group_ids  = [module.vpc.app_sg_id]

  desired_count       = local.ecs_service.desired_count
  assign_public_ip    = local.ecs_service.assign_public_ip

  # ALB configuration
  enable_load_balancer = true
  target_group_arn     = data.aws_lb_target_group.alb.arn
  container_name       = "garden-website-container"
  container_port       = 80

  tags = local.ecs_service.tags
}

locals {
  vpc = {
    vpc_name = "garden-website-vpc"
    vpc_cidr = "10.0.0.0/16"
    tags     = { Environment = "dev" }
    subnets = {
      public-a = {
        cidr_block              = "10.0.8.0/24"
        availability_zone       = "us-east-1a"
        map_public_ip_on_launch = true
      }
      public-b = {
        cidr_block              = "10.0.9.0/24"
        availability_zone       = "us-east-1b"
        map_public_ip_on_launch = true
      }
      private-a = {
        cidr_block              = "10.0.10.0/24"
        availability_zone       = "us-east-1a"
        map_public_ip_on_launch = false
      }
      private-b = {
        cidr_block              = "10.0.11.0/24"
        availability_zone       = "us-east-1b"
        map_public_ip_on_launch = false
      }
    }
  }

  ecs_cluster = {
    name = "garden-website-ecs-cluster"
    tags = { Environment = "dev" }
  }

  ecr_repo_url = "990991767208.dkr.ecr.us-east-1.amazonaws.com/garden-website-repo"

  # Define container definitions inline (no file needed)
  ecs_task = {
    family = "garden-website-task"
    cpu    = "256"
    memory = "512"

    container_definitions = jsonencode([
      {
        name      = "garden-website-container"
        image     = "${local.ecr_repo_url}:latest"
        cpu       = 0
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

    tags = { Environment = "dev" }
  }

  ecs_service = {
    name             = "garden-website-ecs-service"
    desired_count    = 1
    assign_public_ip = false
    tags             = { Environment = "dev" }
  }
}

#################################################################################
# IAM ROLES
#################################################################################

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "garden-ecs-task-execution-role"

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

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_role" {
  name = "garden-ecs-task-role"

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