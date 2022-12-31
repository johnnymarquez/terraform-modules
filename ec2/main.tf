# ------------------------------------------------------------------------------------------------------------
# ------------------------------------------ EC2 Module v1 ---------------------------------------------------
# --------------------------------- No Network Interfaces. Imports Only --------------------------------------
# ------------------------------------------------------------------------------------------------------------

resource "aws_instance" "ec2" {
  ami                     = var.image_id
  instance_type           = var.instance_type
  iam_instance_profile    = var.iam_instance_profile
  monitoring              = var.monitoring
  disable_api_termination = var.disable_api_termination
  ebs_optimized           = true
  key_name                = var.key_name
  vpc_security_group_ids  = var.security_groups
  subnet_id               = var.subnet_id

  user_data = templatefile(var.template, {
    HOSTNAME      = var.name,
    linuxPlatform = "",
    isRPM         = "",
  })

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  tags = {
    stateManager        = var.stateManager
    Creator             = var.creator
    "Cost Center"       = var.cost_center
    Stack               = var.stack
    Name                = var.name
    ControlledByAnsible = var.controlled_by_ansible
  }

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    kms_key_id            = var.kms_key_arn # Arn instead of id to avoid forced replacement.
    volume_size           = var.volume_size
    tags                  = {
      Creator       = var.creator
      "Cost Center" = var.cost_center
      Stack         = var.stack
      Name          = var.name
    }
  }

  lifecycle {
    ignore_changes = [
      ami,
      user_data,
      root_block_device,
    ]
  }
}

resource "aws_eip" "lb" {
  count           = "${var.public_ip ? 1 : 0}"
  instance        = aws_instance.ec2.id
  vpc             = var.public_ip
  }

data "aws_ami" "amazonlinux2" {
  most_recent = true
  owners      = [137112412989]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20211201.0-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
