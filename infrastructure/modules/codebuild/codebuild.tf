resource "aws_codebuild_project" "main" {
  name = var.codebuild_name
  service_role = aws_iam_role.codebuild_pr_workflow.arn
  artifacts {
    type = "NO_ARTIFACTS"
  }
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = var.image
    type = "LINUX_CONTAINER"
    privileged_mode = true
  }
  source {
    type = "CODECOMMIT"
    buildspec = var.buildspec_file
    location = data.aws_codecommit_repository.repo.clone_url_http
  }

  badge_enabled = true
  cache {
    type = "S3"
    location = "${var.bucket_name}/build_cache"
  }
}