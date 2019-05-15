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

resource "aws_wafregional_web_acl" "WAFWebACL" {
    depends_on = ["aws_wafregional_rule.WAFWhitelistRule", "aws_wafregional_rule.WAFBlacklistRule", "aws_wafregional_rule.WAFAutoBlockRule", "aws_wafregional_rule.WAFIPReputationListsRule1", "aws_wafregional_rule.WAFIPReputationListsRule2", "aws_wafregional_rule.WAFBadBotRule", "aws_wafregional_rule.WAFSqlInjectionRule", "aws_wafregional_rule.WAFXssRule","aws_wafregional_rate_based_rule.httpflood"]
    name = "${var.customer}"
    metric_name = "${var.customer}SAMaliciousRequesters"
    default_action {
        type = "ALLOW"
    }
    rule {
        action {
            type = "ALLOW"
        }
        priority = 10
        rule_id = "${aws_wafregional_rule.WAFWhitelistRule.id}"
    }
    rule {
        action {
            type = "BLOCK"
        }
        priority = 20
        rule_id = "${aws_wafregional_rule.WAFBlacklistRule.id}"
    }
    rule {
        action {
            type = "BLOCK"
        }
        priority = 30
        rule_id = "${aws_wafregional_rule.WAFAutoBlockRule.id}"
    }
    rule {
        action {
            type = "BLOCK"
        }
        priority = 40
        rule_id = "${aws_wafregional_rule.WAFIPReputationListsRule1.id}"
    }
    rule {
        action {
            type = "BLOCK"
        }
        priority = 50
        rule_id = "${aws_wafregional_rule.WAFIPReputationListsRule2.id}"
    }
    rule {
        action {
            type = "BLOCK"
        }
        priority = 60
        rule_id = "${aws_wafregional_rule.WAFBadBotRule.id}"
    }
    rule {
        action {
            type = "BLOCK"
        }
        priority = 70
        rule_id = "${aws_wafregional_rule.WAFSqlInjectionRule.id}"
    }
    rule {
        action {
            type = "BLOCK"
        }
        priority = 80
        rule_id = "${aws_wafregional_rule.WAFXssRule.id}"
    }
    rule {
        action {
            type = "BLOCK"
        }
        type = "RATE_BASED"
        priority = 90
        rule_id = "${aws_wafregional_rate_based_rule.httpflood.id}"
    }
    # Example: Fortinet Managed Rules for AWS WAF - Complete OWASP Top 10
    # rule {
    #     override_action {
    #        type = "COUNT"
    #     }
    #     type = "GROUP"
    #     priority = 91
    #     rule_id = "27fde56a-b33f-4ef3-b8ff-143b00163369"
    # }
}
