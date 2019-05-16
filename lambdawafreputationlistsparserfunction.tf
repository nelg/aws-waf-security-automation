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

resource "aws_lambda_function" "LambdaWAFReputationListsParserFunction" {
    # depends_on = ["aws_s3_bucket_object.ReputationListsParserZip"]
    function_name = "${var.customer}-LambdaWAFReputationListsParserFunction"
    description = "This lambda function checks third-party IP reputation lists hourly for new IP ranges to block. These lists include the Spamhaus Dont Route Or Peer (DROP) and Extended Drop (EDROP) lists, the Proofpoint Emerging Threats IP list, and the Tor exit node list."
    role = "${aws_iam_role.LambdaRoleReputationListsParser.arn}"
    handler = "reputation-lists-parser.handler"
    # s3_bucket = "${var.customer}-waflambdafiles"
    # s3_key = "reputation-lists-parser.zip"
    filename = "${path.module}/files/reputation-lists-parser/reputation-lists-parser.zip"
    source_code_hash = "${filebase64sha256("${path.module}/files/reputation-lists-parser/reputation-lists-parser.zip")}"
    runtime = "nodejs8.10"
    memory_size = "128"
    timeout = "300"
    tags = "${var.tags}"
    environment {
        variables = {
            SEND_ANONYMOUS_USAGE_DATA = "${var.SendAnonymousUsageData}"
            METRIC_NAME_PREFIX = "${var.customermetric}"
            LOG_LEVEL = "${var.log_level}"
            UUID = "undef"
        }
    }
}
