data "aws_iam_policy_document" "dome9_readonly" {
  statement {
    sid       = "Dome9ReadOnly"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "cloudtrail:LookupEvents",
      "dynamodb:DescribeTable",
      "elasticfilesystem:Describe*",
      "elasticache:ListTagsForResource",
      "firehose:Describe*",
      "firehose:List*",
      "guardduty:Get*",
      "guardduty:List*",
      "kinesis:List*",
      "kinesis:Describe*",
      "kinesisvideo:Describe*",
      "kinesisvideo:List*",
      "logs:Describe*",
      "logs:Get*",
      "logs:FilterLogEvents",
      "lambda:List*",
      "s3:List*",
      "sns:ListSubscriptions",
      "sns:ListSubscriptionsByTopic",
      "waf-regional:ListResourcesForWebACL",
    ]
  }
}

resource "aws_iam_policy" "dome9_readonly" {
  count = "${var.create_role ? 1 : 0}"

  name   = "dome9-readonly-policy"
  path   = "/"
  policy = "${data.aws_iam_policy_document.dome9_readonly.json}"
}

data "aws_iam_policy_document" "dome9_write" {
  statement {
    sid       = "Dome9Write"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateSecurityGroup",
      "ec2:DeleteSecurityGroup",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:ModifyNetworkInterfaceAttribute",
      "ec2:CreateTags",
      "ec2:DeleteTags",
    ]
  }
}

resource "aws_iam_policy" "dome9_write" {
  count = "${var.create_role ? 1 : 0}"

  name   = "dome9-write-policy"
  path   = "/"
  policy = "${data.aws_iam_policy_document.dome9_write.json}"
}

data "aws_iam_policy_document" "dome9_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account_id}:root"]
    }

    actions = [
      "sts:AssumeRole",
    ]

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"

      values = [
        "${var.external_id}",
      ]
    }
  }
}

resource "aws_iam_role" "dome9_role" {
  count              = "${var.create_role ? 1 : 0}"
  name               = "Dome9Connect"
  assume_role_policy = "${data.aws_iam_policy_document.dome9_role.json}"
}

resource "aws_iam_policy_attachment" "allow_dome9_role_readonly" {
  count      = "${var.create_role ? 1 : 0}"
  name       = "Allow Dome9 PolicyAccess via Role"
  roles      = ["${aws_iam_role.dome9_role.name}"]
  policy_arn = "${aws_iam_policy.dome9_readonly.arn}"
}

resource "aws_iam_policy_attachment" "allow_dome9_role_write" {
  count      = "${var.create_role ? 1 : 0}"
  name       = "Allow Dome9 PolicyAccess via Role"
  roles      = ["${aws_iam_role.dome9_role.name}"]
  policy_arn = "${aws_iam_policy.dome9_write.arn}"
}

resource "aws_iam_policy_attachment" "allow_dome9_role_aws-inspector" {
  count      = "${var.create_role ? 1 : 0}"
  name       = "Allow Dome9 PolicyAccess via Role"
  roles      = ["${aws_iam_role.dome9_role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AmazonInspectorReadOnlyAccess"
}

resource "aws_iam_policy_attachment" "allow_dome9_role_aws-audit" {
  count      = "${var.create_role ? 1 : 0}"
  name       = "Allow Dome9 PolicyAccess via Role"
  roles      = ["${aws_iam_role.dome9_role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}
