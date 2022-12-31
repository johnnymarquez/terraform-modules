resource "aws_ssm_association" "ssm" {
  name                = "AWS-ApplyAnsiblePlaybooks"
  association_name    = var.association_name
  compliance_severity = "UNSPECIFIED"

  parameters = {
    "Check"               = "False"
    "ExtraVariables"      = "SSM=True"
    "InstallDependencies" = "True"
    "PlaybookFile"        = var.playbookfile
    "SourceInfo" = jsonencode(
      {
        "path" : "https://s3.amazonaws.com/ansible/"
      }
    )
    "SourceType"     = "S3"
    "TimeoutSeconds" = "7200"
    "Verbose"        = "-v"
  }

  output_location {
    s3_bucket_name = "ansible"
    s3_key_prefix  = "ansible-output"
  }

  targets {
    key    = var.targets_key
    values = var.targets_values
  }
}
