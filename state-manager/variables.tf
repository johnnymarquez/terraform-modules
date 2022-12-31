variable "name" {
  default = ""
}

variable "association_name" {
  default = ""
}

variable "playbookfile" {
  default = ""
}

variable "targets_key" {
  default = "tag:aws:autoscaling:groupName"
}

variable "targets_values" {
  default = [""]
}