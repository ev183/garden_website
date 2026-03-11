# Website for garden hosted on ECS - Fargate

## Overview
This is a **monolithic static website** built with HTML/CSS/JavaScript and served via Nginx in a Docker container. I chose a simple architecture to focus on DevOps practices like infrastructure automation, containerization, and CI/CD pipelines. 
> [!NOTE]
> This could certainly be done with a simpler (and cheaper!!) setup ;ike S3+CloudFront I but wanted to dive into more advanced devops practices.

## Website design
Majority of the frontend code was produced via Claude Code. I update weekly with information from my garden.

## CI/CD Workflow
I utilize GitHub Actions to acheive a CI/CD workflow. Followed [GitHub's CI/CD best practice documentation.](https://github.com/github/awesome-copilot/blob/main/instructions/github-actions-ci-cd-best-practices.instructions.md)
Everytime I push code to main (did not feel the need for branching as its just me working on this), I have a github action that...
 1. builds a new image and tags it with latest and my commit hash (shortened to 7 characters). 
 2. It pushes the image to my ECR. 
 3. My ECS Service task definition is revised to use that latest image. 
 4. Also, if not already done so, my ECS Service desired task count is set to 1. 

Instead of relying on GitHub-managed runners, I've implemented self-hosted runners using k3d clusters on my local machine. GitHub Actions Runner Controller (ARC), deployed via the official Helm chart, ensures a runner pod is always available for pipeline execution. I am considering building out a k3 cluster with 2 or 3 rasperry pi's and acheiving the same setup.

## AWS Architecture
### Docker + ECR Repository
I have created an ECR repository that holds the nginx image for the website. 
My repository also has lifecycle policies in place to archive and eventually delete unused images

### ECS Cluster
Nothing special about it. Just a logical container for my Service/its tasks. Not using namespaces or capacity providers.

### ECS Service
I chose to create an ECS Service running in Fargate mode to explore a fully serverless setup + only pay for actual task usage instead of paying for EC2 instances.

### ECS Task Definition
The task is designed to run on a service with a fargate launch type. The task definition is set to use the latest image in my ECR repo. A task's specs are 0.25 vCPU and 512 mb of RAM.

## To-Do (maybe)
- Create some sort of testing in my CI/CD pipeline. Tests must pass before proceeding with the deployment
- Have ECS logs go to CloudWatch (and then maybe Grafana?)
- Start using tfsec to analyze my IaC code for gaps/risks