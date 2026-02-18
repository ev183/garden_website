module "vpc" {
  source = "../modules/vpc"

  vpc_name = local.vpc.vpc_name
  vpc_cidr = local.vpc.vpc_cidr
  subnets  = local.vpc.subnets
  tags     = local.vpc.tags
}

module "alb" {
  source = "../modules/alb"
  
  alb_name              = "garden-website-alb"
  create_security_group = true
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = module.vpc.subnet_ids
}

module "ecs_cluster" {
  source = "../modules/ecs_cluster"

  cluster_name = local.ecs_cluster.name
  tags         = local.ecs_cluster.tags
}

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

module "ecs_service" {
  source = "../modules/ecs_service"

  service_name        = local.ecs_service.name
  cluster_arn         = module.ecs_cluster.cluster_arn
  task_definition_arn = module.ecs_task.task_definition_arn

  subnet_ids          = module.vpc.subnet_ids
  security_group_ids  = [module.vpc.app_sg_id]

  desired_count       = local.ecs_service.desired_count
  assign_public_ip    = local.ecs_service.assign_public_ip

  # ALB configuration
  enable_load_balancer = true
  target_group_arn     = module.alb.target_group_arn
  container_name       = "garden-website-container"
  container_port       = 80

  tags = local.ecs_service.tags
}

locals {
  vpc = {
    vpc_name = "garden-website-vpc"
    vpc_cidr = "10.0.0.0/16"
    tags     = { Environment = "dev" }
    igw = {
      name = "garden-website-igw"
    }

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
  }
  }

  ecs_cluster = {
    name = "garden-website-ecs-cluster"
    tags = { Environment = "dev" }
  }

  ecr_repo_url = "990991767208.dkr.ecr.us-east-1.amazonaws.com/garden-website-repo"

  ecs_task = {
    family                = "garden-website-task"
    cpu                   = 256
    memory                = 512

    container_definitions = jsonencode([{
    name      = "garden-website-container"
    image     = "${local.ecr_repo_url}:v3"
    essential = true
    execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
    task_role_arn      = aws_iam_role.ecs_task_role.arn
    portMappings = [
      {
        containerPort = 80      
        hostPort      = 80
        protocol      = "tcp"
      }
    ]
  }
])

    tags                  = { Environment = "dev" }
  }

# Create the ECS service with 0 desired count to prevent immediate task launch
  ecs_service = {
    name             = "garden-website-ecs-service"
    desired_count    = 0
    assign_public_ip = true
    tags             = { Environment = "dev" }
  }
}


#################################################################################
##################################################################################

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