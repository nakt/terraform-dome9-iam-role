output "dome9_role_arn" {
  value       = "${aws_iam_role.dome9_role.*.arn}"
  description = "IAM role ARN for Dome9 assume account."
}
