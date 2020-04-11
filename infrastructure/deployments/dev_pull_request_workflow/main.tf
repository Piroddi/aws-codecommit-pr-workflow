terraform {
  required_version = ">= 0.12, < 0.13"
}

provider "aws" {
  region = "<<REGION>>"

  # Allow any 2.x version of the AWS provider
  version = "~> 2.0"
}

module "pr_workflow_codebuild" {
  source = "../../modules/codebuild"
  bucket_name = "pr-workflow"
  buildspec_file = "pull_request_buildspec.yaml"
  codebuild_name = "pr_workflow"
  image = "aws/codebuild/standard:2.0"
  repo = "sample_spring_application"
  codebuild_feature_pr_role = "codebuild-pr-workflow-role"
  codebuild_feature_pr_role_policy = "codebuild_pr_workflow_policy"
  account_id = "<<ACCOUNT NO>>"
  region = "<<REGION>>"
}

module "pr_workflow_cloudwatch" {
  source = "../../modules/cloudwatch"
  cloudwatch_feature_pr_role = "cloudwatch_pr_workflow_role"
  cloudwatch_feature_pr_role_policy = "cloudwatch_pr_workflow_policy"
  event_description = "Trigger CodeBuild on creation of pull request"
  event_name = "pr_workflow"
  resource_arn = module.pr_workflow_codebuild.codebuild_arn
  target_id = "pr_workflow_trigger"
  repo = "sample_spring_application"
}