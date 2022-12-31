variable "bucket" {
  default = ""

}

variable "target_bucket" {
  default = "s3-generals-logs"

}

variable "target_prefix" {
  default = ""
  
}

variable "hosted_zone_id" {
  default = ""
  
}

variable "object_lock_enabled" {
  default = false
}

variable "tags_all" {
  default = {
    
  }
}

variable "lambda_function_arn" {
  default = "arn:aws:lambda:us-east-1::function:"
}

variable "filter_prefix" {
  default = "securityhub"
  
}

variable "versioning_configuration" {
  default = "Disabled"
  
}

variable "eventbridge" {
  default = false
  
}