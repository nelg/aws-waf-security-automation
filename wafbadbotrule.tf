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

resource "aws_wafregional_rule" "WAFBadBotRule" {
    depends_on = ["aws_wafregional_ipset.WAFBadBotSet"]
    name = "${var.customer} - Bad Bot Rule"
   metric_name = "${var.customermetric}SABadBotRule"
    predicate {
        data_id = "${aws_wafregional_ipset.WAFBadBotSet.id}"
        negated = false
        type = "IPMatch"
    }
}
