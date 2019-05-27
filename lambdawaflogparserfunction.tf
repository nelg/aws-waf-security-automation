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

data "archive_file" "LambdaWAFLogParserFunction" {
  type        = "zip"
  source_file = "${path.module}/files/log-parser/log-parser.py"
  output_path = "${path.module}/files/log-parser/log-parser.zip"
}

resource "aws_lambda_function" "LambdaWAFLogParserFunction" {
  # depends_on = ["aws_s3_bucket_object.LogParserZip"]
  function_name = "${var.customer}-LambdaWAFLogParserFunction"
  description   = "This function parses CloudFront access logs to identify suspicious behavior, such as an abnormal amount of requests or errors. It then blocks those IP addresses for a customer-defined period of time."
  role          = aws_iam_role.LambdaRoleLogParser.arn
  handler       = "log-parser.lambda_handler"

  #s3_bucket = "solutions-${var.aws_region}"
  #s3_key = "aws-waf-security-automations/v1/log-parser.zip"
  # s3_bucket = "${var.customer}-waflambdafiles"
  # s3_key = "log-parser.zip"
  filename         = data.archive_file.LambdaWAFLogParserFunction.output_path
  source_code_hash = data.archive_file.LambdaWAFLogParserFunction.output_base64sha256
  runtime          = "python3.7"
  memory_size      = "512"
  timeout          = "300"
  tags             = var.tags
  environment {
    variables = {
      UUID                                           = "undef"
      OUTPUT_BUCKET                                  = var.CloudFrontAccessLogBucket
      IP_SET_ID_BLACKLIST                            = aws_wafregional_ipset.WAFBlacklistSet.id
      IP_SET_ID_AUTO_BLOCK                           = aws_wafregional_ipset.WAFAutoBlockSet.id
      BLACKLIST_BLOCK_PERIOD                         = var.WAFBlockPeriod
      ERROR_PER_MINUTE_LIMIT                         = var.ErrorThreshold
      REQUEST_PER_MINUTE_LIMIT                       = var.RequestThreshold
      SEND_ANONYMOUS_USAGE_DATA                      = var.SendAnonymousUsageData
      LIMIT_IP_ADDRESS_RANGES_PER_IP_MATCH_CONDITION = "10000"
      MAX_AGE_TO_UPDATE                              = "30"
      REGION                                         = var.aws_region
      LOG_TYPE                                       = "alb"
      METRIC_NAME_PREFIX                             = var.customermetric
      LOG_LEVEL                                      = var.log_level
      STACK_NAME                                     = "${var.customer}-LogParser-data"
    }
  }
}

