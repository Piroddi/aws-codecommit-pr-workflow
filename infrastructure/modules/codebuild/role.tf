resource "aws_iam_role" "codebuild_pr_workflow" {
  name = var.codebuild_feature_pr_role
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "codebuild_pr_workflow" {
  name = var.codebuild_feature_pr_role_policy
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:CreateReportGroup",
        "codebuild:CreateReport",
        "codebuild:UpdateReport",
        "codebuild:BatchPutTestCases"
      ],
      "Resource": "${aws_iam_role.codebuild_pr_workflow.arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/codebuild/${var.codebuild_name}:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketAcl",
        "s3:GetBucketLocation"
      ],
      "Resource": "${aws_s3_bucket.main.arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codecommit:GitPull",
        "codecommit:PostCommentForPullRequest",
        "codecommit:UpdatePullRequestApprovalState"
      ],
      "Resource": "${data.aws_codecommit_repository.repo.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "codebuild_pr_workflow" {
  role       = aws_iam_role.codebuild_pr_workflow.name
  policy_arn = aws_iam_policy.codebuild_pr_workflow.arn
}