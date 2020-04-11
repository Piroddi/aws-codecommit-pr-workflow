data "aws_codecommit_repository" "repo" {
  repository_name = var.repo
}