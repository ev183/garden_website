# Website for garden hosted on ECS - Fargate

## Overview
This is a **monolithic static website** built with HTML/CSS/JavaScript and served via Nginx in a Docker container. I chose a simple architecture to focus on DevOps practices like infrastructure automation, containerization, and CI/CD pipelines. 
> [!NOTE]
> This could certainly be done with a simpler setup but wanted to dive into more advanced devops practices.

## Website design
Majority of the frontend code was produced via Claude Code. I update weekly with information from my garden.

## Architecture
### CI/CD Workflow
Everytime I push code to main, I have a github action that builds a new image and tags it with latest and my commit hash (shortened to 7 characters). It pushes the image to my ECR. Then my ECS Service task definition is revised to use that latest image. Also, if not already done so, my ECS Service desired task count is set to 1. 

### GitHub Runners
Instead of relying on GitHub-managed runners, I've implemented self-hosted runners using k3d clusters on my local machine. GitHub Actions Runner Controller (ARC), deployed via the official Helm chart, ensures a runner pod is always available for pipeline execution. I am considering building out a k3 cluster with 2 or 3 rasperry pi's and acheiving the same setup.

### Docker + ECR Repository
I have created an ECR repository that holds the nginx image for the website. I have a dockerfile that creates the image and it is then pushed to the ECR repository (usually via my pipeline).

```bash
docker build -t garden-website-repo -f docker/Dockerfile .
docker tag garden-website-repo:latest 990991767208.dkr.ecr.us-east-1.amazonaws.com/garden-website-repo:v2
docker push 990991767208.dkr.ecr.us-east-1.amazonaws.com/garden-website-repo:v2
```

My repository also has lifecycle policies in place to archive and eventually delete unused images

### ECS Cluster
Nothing special about it. Just a logical container for my Service/its tasks. Not using namespaces or capacity providers.

### ECS Service
I chose to create an ECS Service running in Fargate mode to explore a fully serverless setup + only pay for actual task usage instead of paying for EC2 instances.

### ECS Task Definition
The task is designed to run on a service with a fargate launch type. The task definition is set to use the latest image in my ECR repo. A task's specs are 0.25 vCPU and 512 mb of RAM