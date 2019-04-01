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

###############################################################################
# CUSTOM CONFIGURATION    #
# Let 'waf' script change #
###########################

variable "tags" {
  default = {}
}

variable "elb_association" {
  description = "ALB ARNs to associate"
}

variable "elb_s3_prefix" {
    description = "Prefix in s3 bucket that ELB logs to.  This may be the Env or Customer"
    default = ""
}

resource "aws_wafregional_web_acl_association" "alb_association" {
  resource_arn = "${var.elb_association}"
  web_acl_id   = "${aws_wafregional_web_acl.WAFWebACL.id}"
}

variable "customer" {
    description = "[REQUIRED] Env/Customer/Project Name (max 15 characters):"
}

variable "CloudFrontAccessLogBucket" {
    description = "[REQUIRED] CDN S3 Logs Bucket:"
}
###############################################################################


###############################################################################
# CUSTOM VARIABLES - TUNNING WAF #
#   BE CAREFUL, MASSIVE IMPACT   #
##################################
#default = "50"
variable "ErrorThreshold" {
    default = "500"
}
#default = "400"
variable "RequestThreshold" {
    default = "800"
}
variable "WAFBlockPeriod" {
    default = "240"
}
variable "log_level" {
    default = "DEBUG"
  
}
variable "flood_rate" {
    default = "2000"
}



###############################################################################
# IMPROVE AWS WAF #
###################
# Helps Amazon tune WAF functionality - highly recommended
variable "SendAnonymousUsageData" {
    default = "no"
}

# used for API gateway
variable "aws_region" {
    default     = "ap-southeast-2"
}


###############################################################################
# GET AWS ACCOUNT #
###################
data "aws_caller_identity" "current" { }
# output "account_id" {
#     value = "${data.aws_caller_identity.current.account_id}"
# }
