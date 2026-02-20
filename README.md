# Website for garden hosted on ECS - Fargate

## Docker + ECR Repository
I have created an ECR repositoy that holds the nginx image for the website. I have a dockerfile that creates the image and it is then pushed to the ECR repository. 

1. I run 'docker build -t garden-website-repo -f docker/Dockerfile .' to build the latest image.
2. Then I tag it 'docker tag garden-website-repo:latest 990991767208.dkr.ecr.us-east-1.amazonaws.com/garden-website-repo:v2'
3. Then I push it to my ECR 'docker push 990991767208.dkr.ecr.us-east-1.amazonaws.com/garden-website-repo:v2'

My repository also has lifecycle policies in place to archive and eventually delete unused images

## ECS Cluster

Nothing special about it. Just a logical container for my Service/its tasks. Not using namespaces or capactiy providers.

## ECS Service

I chose to create an ECS Service running in Fargate mode to explore a fully serverless setup + only pay for actual task usage instead of paying for EC2 instances.

## ECS Task Definition

The task is designed to run on a service with a fargate launch type. The task definition is set to use the latest image in my ECR repo. A task's specs are 0.25 vCPU and 512 mb of RAM

## Networking