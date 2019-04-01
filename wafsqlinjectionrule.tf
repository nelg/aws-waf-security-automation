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

resource "aws_wafregional_rule" "WAFSqlInjectionRule" {
    depends_on = ["aws_wafregional_sql_injection_match_set.WAFSqlInjectionDetection"]
    name = "${var.customer} - SQL Injection Rule"
    metric_name = "${var.customer}SASqlInjectionRule"
    predicate {
        data_id = "${aws_wafregional_sql_injection_match_set.WAFSqlInjectionDetection.id}"
        negated = false
        type = "SqlInjectionMatch"
      }
}
