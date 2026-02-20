# Reference ALB outputs from website_alb using Terragrunt dependencies
dependency "alb" {
	config_path = "../website_alb"
}
