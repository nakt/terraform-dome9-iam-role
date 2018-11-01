# Create IAM Role for Dome9

Terraform module which create IAM role for Dome9.

## Usage

```
module "dome9_iam_role" {
  source = "git::https://github.com/nakt/terraform-dome9-iam-role"

  create_role = true
  account_id  = "123456789101"
  external_id = "abcdefghijklmnopqrstuvwx"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| account_id | Account ID from the Dome9 console. | string | `` | no |
| create_role | Control if policy for dome9 should be created. | string | `true` | no |
| external_id | External ID from the Dome9 console. | string | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| dome9_role_arn | IAM role ARN for Dome9 assume account. |

