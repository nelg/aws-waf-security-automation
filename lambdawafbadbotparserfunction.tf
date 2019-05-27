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
data "archive_file" "LambdaWAFBadBotParserFunction" {
  type        = "zip"
  source_file = "${path.module}/files/access-handler/access-handler.py"
  output_path = "${path.module}/files/access-handler/access-handler.zip"
}

resource "aws_lambda_function" "LambdaWAFBadBotParserFunction" {
  # depends_on = ["aws_s3_bucket_object.AccessHandlerZip"]
  function_name    = "${var.customer}-LambdaWAFBadBotParserFunction"
  description      = "This lambda function will intercepts and inspects trap endpoint requests to extract its IP address, and then add it to an AWS WAF block list."
  role             = aws_iam_role.LambdaRoleBadBot.arn
  handler          = "access-handler.lambda_handler"
  filename         = data.archive_file.LambdaWAFBadBotParserFunction.output_path
  source_code_hash = data.archive_file.LambdaWAFBadBotParserFunction.output_base64sha256
  runtime          = "python3.7"
  memory_size      = "128"
  timeout          = "300"
  tags             = var.tags
  environment {
    variables = {
      UUID                      = "undef"
      IP_SET_ID_BAD_BOT         = aws_wafregional_ipset.WAFBadBotSet.id
      SEND_ANONYMOUS_USAGE_DATA = var.SendAnonymousUsageData
      REGION                    = var.aws_region
      LOG_TYPE                  = "alb"
      METRIC_NAME_PREFIX        = var.customermetric
      LOG_LEVEL                 = var.log_level
    }
  }
}

# {
#   "headers": {
#   "X-Forwarded-For": "192.168.1.1"
#   }
# }
