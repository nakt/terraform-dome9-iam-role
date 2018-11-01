variable "create_role" {
  type        = "string"
  default     = true
  description = "Control if policy for dome9 should be created."
}

variable "external_id" {
  type        = "string"
  default     = ""
  description = "External ID from the Dome9 console."
}

variable "account_id" {
  type        = "string"
  default     = ""
  description = "Account ID from the Dome9 console."
}
