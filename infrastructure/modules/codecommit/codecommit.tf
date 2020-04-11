resource "aws_codecommit_repository" "main" {
  repository_name = var.repo
  description     = var.description
  default_branch = "develop"
}