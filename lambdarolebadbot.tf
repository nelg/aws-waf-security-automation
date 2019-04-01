###############################################################################
#   Copyright 2016 Cerbo.IO, LLC.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
###############################################################################

resource "aws_iam_role" "LambdaRoleBadBot" {
    name = "${var.customer}-LambdaRoleBadBot"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
    path = "/"
    tags = "${var.tags}"
}
resource "aws_iam_role_policy" "LambdaRoleBadBotWAFGetChangeToken" {
    name = "${var.customer}-LambdaRoleBadBotWAFGetChangeToken"
    role = "${aws_iam_role.LambdaRoleBadBot.id}"
    policy = <<EOF
{
  "Statement": [
    {
      "Action": [
        "waf-regional:GetChangeToken"
      ],
      "Effect": "Allow",
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}
resource "aws_iam_role_policy" "LambdaRoleBadBotWAFGetAndUpdateIPSet" {
    name = "${var.customer}-LambdaRoleBadBotWAFGetAndUpdateIPSet"
    role = "${aws_iam_role.LambdaRoleBadBot.id}"
    policy = <<EOF
{
  "Statement": [
    {
      "Action": [
        "waf-regional:GetIPSet",
        "waf-regional:UpdateIPSet"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:waf-regional:${var.aws_region}:${data.aws_caller_identity.current.account_id}:ipset/${aws_wafregional_ipset.WAFBadBotSet.id}"
      ]
    }
  ]
}
EOF
}
resource "aws_iam_role_policy" "LambdaRoleBadBotLogsAccess" {
    name = "${var.customer}-LambdaRoleBadBotLogsAccess"
    role = "${aws_iam_role.LambdaRoleBadBot.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*"
      ]
    }
  ]
}
EOF
}
resource "aws_iam_role_policy" "LambdaRoleBadBotCloudWatchAccess" {
    name = "${var.customer}-LambdaRoleBadBotCloudWatchAccess"
    role = "${aws_iam_role.LambdaRoleBadBot.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "cloudwatch:GetMetricStatistics",
      "Effect": "Allow",
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}
