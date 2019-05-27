resource "aws_wafregional_rate_based_rule" "httpflood" {
  name        = "${var.customer} - HTTP Flood Rule"
  metric_name = "${var.customermetric}SAHttpFloodRule"

  rate_key   = "IP"
  rate_limit = var.flood_rate
}

