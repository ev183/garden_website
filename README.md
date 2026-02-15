# Website for garden hosted on ECS - Fargate

## Docker + ECR Repository
I have created an ECR repositoy that holds the nginx image for the website. I have a dockerfile that creates the image and it is then pushed to the ECR repository. 

1. I run 'docker build -t garden-website-repo -f docker/Dockerfile .' to build the latest image.
2. Then I tag it 'docker tag garden-website-repo:latest 990991767208.dkr.ecr.us-east-1.amazonaws.com/garden-website-repo:v2'
3. Then I push it to my ECR 'docker push 990991767208.dkr.ecr.us-east-1.amazonaws.com/garden-website-repo:v2'

## ECS Cluster

## ECS Service

## ECS Task

## ECS Networking