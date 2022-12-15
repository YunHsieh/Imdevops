resource "aws_iam_role" "imbee_lambda_developer" {
  name = "Imbee-Lambda-Developer"

  assume_role_policy = jsonencode({
        Version="2012-10-17",
        Statement=[
            {
                Effect="Allow",
                Principal={
                    Service="lambda.amazonaws.com"
                },
                Action="sts:AssumeRole"
            }
        ]
    })
}

resource "aws_iam_policy" "sqs_full_access" {
  name        = "SQS-Full-Access"
  description = "A test policy"

  policy = jsonencode({
        Version="2012-10-17",
        Statement=[
            {
                Sid="VisualEditor0",
                Effect="Allow",
                Action="sqs:*",
                Resource="*"
            }
        ]
    })
}

resource "aws_iam_policy" "lambda_log_policy" {
    name   = "Lambda-Log-Policy"
    policy = jsonencode({
        Version="2012-10-17",
        Statement=[
            {
                Action=[
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ],
                Effect="Allow",
                Resource="arn:aws:logs:${var.region}:*:*"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "sqs-attach" {
  role       = aws_iam_role.imbee_lambda_developer.name
  policy_arn = aws_iam_policy.sqs_full_access.arn
}

resource "aws_iam_role_policy_attachment" "lambda-attach" {
  role       = aws_iam_role.imbee_lambda_developer.name
  policy_arn = aws_iam_policy.lambda_log_policy.arn
}
