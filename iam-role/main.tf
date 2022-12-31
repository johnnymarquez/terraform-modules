resource "aws_iam_role" "role" {
  name                = var.name
  inline_policy   { 
    name = var.namepolicy
    policy = var.jsonpolicy
  }
  path                = var.path
  managed_policy_arns = var.managed_policy_arns
  description         = var.description
  force_detach_policies = var.force_detach_policies

  assume_role_policy = jsonencode(
  {
    Statement = [
      {
        Principal = {
          Service = var.service
        }
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Sid       = ""
      }
    ]
    Version   = "2012-10-17"
  }
  )
}

resource "aws_iam_instance_profile" "profile" {
  name = var.profile_name
  role = aws_iam_role.role.name
}