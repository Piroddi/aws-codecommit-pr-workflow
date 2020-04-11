resource "aws_iam_role" "cloudwatch_pr" {
  name = var.cloudwatch_feature_pr_role
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "cloudwatch_pr" {
  name = var.cloudwatch_feature_pr_role_policy
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:StartBuild"
      ],
      "Resource": "${var.resource_arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "cloudwatch_pr" {
  role       = aws_iam_role.cloudwatch_pr.name
  policy_arn = aws_iam_policy.cloudwatch_pr.arn
}