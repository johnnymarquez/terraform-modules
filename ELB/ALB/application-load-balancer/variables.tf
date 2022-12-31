variable "alb_name" {
  default = "zerorate-alb-py-01"
}

variable "security_groups" {
  default = ["sg-0ff1eb8bb5b0404c4"]
}

variable "subnets" {
  default = ["subnet-06446aaaf42d9d886", "subnet-0f8469c7da6ffb1ed"]
}

variable "alb_tag_name" {
  default = "zerorate-alb-py"
}

variable "alb_target_group_80_name" {
  default = "zerorate-alb-tg-py-80-01"
}

variable "alb_target_group_443_name" {
  default = "zerorate-alb-tg-py-443-01"
}

variable "vpc_id" {
  default = "vpc-0b04297534bc8309d"
}

variable "creator" {
  default = "nicodemo.peloso@globant.com"
}

variable "cost_center" {
  default = "ZerorateProxy"
}

variable "stack" {
  default = "Production"
}

variable "certificate_arn_suffix" {
  default = "484b47bf-fd26-44d1-b170-79a1c8683fa5"
}

variable "healthcheck_path" {
  default = "/_proxy/healthcheck"
}

variable "drop_invalid_header_fields" {
  default = true
}

variable "interval" {
  default = 10
}

variable "enable_deletion_protection" {
  default = true
}

variable "access_logs_enabled" {
  default = true
}

variable "access_logs_bucket" {
  default = "aws.logs.elb.com"
}

variable "access_logs_prefix" {
  default = ""
}

variable "listener_443_port" {
  default = "443"
}

variable "listener_443_protocol" {
  default = "HTTPS"
}

variable "listener_443_ssl_policy" {
  default = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
}

variable "listener_443_certificate_arn" {
  default = "arn:aws:acm:us-east-1:045837062796:certificate/48ef8de7-314a-400a-811c-f5ed71a5769b"
}

variable "listener_80_redirect_port" {
  default = "443"
}

variable "listener_80_redirect_protocol" {
  default = "HTTPS"
}

variable "listener_80_redirect_status_code" {
  default = "HTTP_301"
}

variable "listener_80_port" {
  default = "80"
}

variable "listener_80_protocol" {
  default = "HTTP"
}