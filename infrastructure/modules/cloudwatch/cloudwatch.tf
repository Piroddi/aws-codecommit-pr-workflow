resource "aws_cloudwatch_event_rule" "main" {
  name = var.event_name
  description = var.event_description

  event_pattern = <<PATTERN
{
  "detail-type": [
    "CodeCommit Pull Request State Change"
  ],
  "resources": [
     "${data.aws_codecommit_repository.repo.arn}"
  ],
  "source": [
    "aws.codecommit"
  ],
  "detail": {
    "event": [
      "pullRequestCreated",
      "pullRequestSourceBranchUpdated"
    ]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "main" {
  arn = var.resource_arn
  rule = aws_cloudwatch_event_rule.main.name
  target_id = var.target_id
  role_arn = aws_iam_role.cloudwatch_pr.arn
  input_transformer {
    input_template = <<DOC
{
  "sourceVersion": <sourceVersion>,
  "artifactsOverride": {"type": "NO_ARTIFACTS"},
  "environmentVariablesOverride": [
     {
         "name": "PULL_REQUEST_ID",
         "value": <pullRequestId>,
         "type": "PLAINTEXT"
     },
     {
         "name": "REPOSITORY_NAME",
         "value": <repositoryName>,
         "type": "PLAINTEXT"
     },
     {
         "name": "SOURCE_COMMIT",
         "value": <sourceCommit>,
         "type": "PLAINTEXT"
     },
     {
         "name": "DESTINATION_COMMIT",
         "value": <destinationCommit>,
         "type": "PLAINTEXT"
     },
     {
        "name" : "REVISION_ID",
        "value": <revisionId>,
        "type": "PLAINTEXT"
     }
  ]
}
  DOC
    input_paths = {
      sourceVersion: "$.detail.sourceCommit"
      pullRequestId: "$.detail.pullRequestId"
      repositoryName: "$.detail.repositoryNames[0]"
      sourceCommit: "$.detail.sourceCommit"
      destinationCommit: "$.detail.destinationCommit"
      revisionId: "$.detail.revisionId"
    }
  }

}