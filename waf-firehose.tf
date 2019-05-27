data "aws_iam_policy_document" "assume-firehose" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"

      values = [
        data.aws_caller_identity.current.account_id,
      ]
    }
  }
}

resource "aws_iam_role" "firehose_role" {
  count = var.waf_firehose ? 1 : 0
  name               = "${var.customer}firehose"
  assume_role_policy = data.aws_iam_policy_document.assume-firehose.json
}

data "aws_s3_bucket" "loggingbucket" {
  bucket = var.CloudFrontAccessLogBucket
}

resource "aws_cloudwatch_log_group" "kinesis-waf" {
  count = var.waf_firehose ? 1 : 0
  retention_in_days = 5
  name              = "kinesis-waf-${var.customer}"
  tags              = var.tags
}

resource "aws_cloudwatch_log_stream" "waf" {
  count = var.waf_firehose ? 1 : 0
  log_group_name = aws_cloudwatch_log_group.kinesis-waf.name
  name           = var.customer
}

resource "aws_kinesis_firehose_delivery_stream" "waf" {
  count = var.waf_firehose ? 1 : 0
  name        = "aws-waf-logs-${var.customer}"
  destination = "extended_s3"
  tags        = var.tags

  extended_s3_configuration {
    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.kinesis-waf.name
      log_stream_name = var.customer
    }

    error_output_prefix = "AWSWAF-errors"
    prefix              = "AWSWAF-logs"
    role_arn            = aws_iam_role.firehose_role.arn
    bucket_arn          = data.aws_s3_bucket.loggingbucket.arn
  }
}

resource "aws_iam_role_policy" "kinesis" {
  count = var.waf_firehose ? 1 : 0
  role   = aws_iam_role.firehose_role.id
  policy = data.aws_iam_policy_document.kinesis.json
  name   = "${var.customer}-kinesis"
}

data "aws_iam_policy_document" "kinesis" {
  statement {
    effect = "Allow"

    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
    ]

    resources = [
      data.aws_s3_bucket.loggingbucket.arn,
      "${data.aws_s3_bucket.loggingbucket.arn}/*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "kinesis:DescribeStream",
      "kinesis:GetShardIterator",
      "kinesis:GetRecords",
    ]

    resources = [
      "arn:aws:kinesis:${var.aws_region}:${data.aws_caller_identity.current.account_id}:stream/aws-waf-logs-${var.customer}",
    ]
  }

  statement {
    actions = ["logs:PutLogEvents"]

    resources = [
      "arn:aws:kinesis:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/kinesisfirehose/aws-waf-logs-${var.customer}",
    ]
  }
}

