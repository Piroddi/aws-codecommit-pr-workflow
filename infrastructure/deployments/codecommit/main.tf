terraform {
  required_version = ">= 0.12, < 0.13"
}

provider "aws" {
  region = "eu-west-1"

  # Allow any 2.x version of the AWS provider
  version = "~> 2.0"
}

module "codecommit_application" {
  source = "../../modules/codecommit"
  description = "A default string application, to test feature pull request workflow"
  repo = "sample_spring_application"
}

