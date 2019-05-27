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

resource "aws_wafregional_sql_injection_match_set" "WAFSqlInjectionDetection" {
  name = "${var.customer} - SQL Injection Detection"
  sql_injection_match_tuple {
    text_transformation = "URL_DECODE"
    field_to_match {
      type = "QUERY_STRING"
    }
  }
  sql_injection_match_tuple {
    text_transformation = "HTML_ENTITY_DECODE"
    field_to_match {
      type = "HEADER"
      data = "cookie"
    }
  }
  sql_injection_match_tuple {
    text_transformation = "HTML_ENTITY_DECODE"
    field_to_match {
      type = "QUERY_STRING"
    }
  }
  sql_injection_match_tuple {
    text_transformation = "URL_DECODE"
    field_to_match {
      type = "BODY"
    }
  }
  sql_injection_match_tuple {
    text_transformation = "HTML_ENTITY_DECODE"
    field_to_match {
      type = "BODY"
    }
  }
  sql_injection_match_tuple {
    text_transformation = "URL_DECODE"
    field_to_match {
      type = "URI"
    }
  }
  sql_injection_match_tuple {
    text_transformation = "HTML_ENTITY_DECODE"
    field_to_match {
      type = "URI"
    }
  }
  sql_injection_match_tuple {
    text_transformation = "URL_DECODE"
    field_to_match {
      type = "HEADER"
      data = "authorization"
    }
  }
  sql_injection_match_tuple {
    text_transformation = "HTML_ENTITY_DECODE"
    field_to_match {
      type = "HEADER"
      data = "authorization"
    }
  }
  sql_injection_match_tuple {
    text_transformation = "URL_DECODE"
    field_to_match {
      type = "HEADER"
      data = "cookie"
    }
  }
}

