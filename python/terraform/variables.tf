variable "project" {
  type        = string
  description = "(Required) Project id."
}

variable "credentials_file" {
  type        = string
  description = "(Required) Path to service account credentials file. Set up in environment as TF_VAR_<variable_name>"
}
