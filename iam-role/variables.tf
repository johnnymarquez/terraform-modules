variable "name" {
  default = ""
}

variable "path" {
  default = "/service-role/"
}

variable "managed_policy_arns" {
  default = []
}

variable "service" {
  default = "lambda.amazonaws.com"
}

variable "description" {
  default = ""
}

variable "profile_name" {
  default = ""
}

variable "tags" {
  default = {
    Creator = ""
  }
}

variable "force_detach_policies" {
  default = false
}

variable "max_session_duration" {
  default = 3600
}

variable "inline_policy" {
  default = {}
}

variable "namepolicy" {
  default = "policy"
}

variable "jsonpolicy" {
  default = {}
}