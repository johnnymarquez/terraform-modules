variable "name" {
  default = "-prod"
}

variable "instance_type" {
  default = "m5.large"
}

variable "public_ip" {
  default = false
}

variable "instance_id" {
  default = ""
}

variable "stateManager" {
  default = ""
}

variable "iam_instance_profile" {
  default = "infra-role-ssm2"           # Required for systems manager
}

variable "security_groups" {
  default = ["sg-"]    # -prd-sg-01
}

variable "subnet_id" {
  default = "subnet-"  # -prd-private-1a
}

variable "availability_zone" {
  default = "us-east-1a"
}

variable "disable_api_termination" {
  default = "true"
}

variable "kms_key_arn" {
  default = ""
}

variable "creator" {
  default = "test@.com"
}

variable "cost_center" {
  default = ""
}

variable "stack" {
  default = "Production"
}

variable "controlled_by_ansible" {
  default = "False"
}

variable "country" {
  default = ""
}

variable "ec2_number" {
  default = "01"
}

variable "monitoring" {
  default = true
}

variable "device" {
  default = "/dev/xvda"
}

variable "template" {
  default = ("")
}

variable "key_name" {
  default = "ansible"
}

variable "image_id" {
  default = "ami-"
}

variable "volume_size"{
  default = 16
}
