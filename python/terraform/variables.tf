variable "project" {
  type        = string
  description = "(Required) Project id."
}
variable "sa_email" {
  type        = string
  description = "(Required) Email of service account for terraform."
}
variable "forecast_email" {
  type        = string
  description = "(Required) Email of Forecast account."
}
variable "sky_email" {
  type        = string
  description = "(Required) Email of Sky account."
}

variable "sa_credentials" {
  type        = string
  description = "(Required) Path to service account credentials file. Set up in environment as TF_VAR_<variable_name>"
}

variable "data" {
  type        = string
  description = "(Required) Secret data. Set up in environment as TF_VAR_<variable_name>"
}
