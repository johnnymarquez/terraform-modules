resource "aws_globalaccelerator_accelerator" "global_accelerator" {
  name            = var.name
  ip_address_type = "IPV4"
  enabled         = true

  attributes {
    flow_logs_enabled = false
  }

  tags = {
    Creator       = var.creator
    "Cost Center" = var.cost_center
    Stack         = var.stack
  }
}

resource "aws_globalaccelerator_listener" "listener" {
  accelerator_arn = aws_globalaccelerator_accelerator.global_accelerator.id
  client_affinity = "NONE"
  protocol        = "TCP"

  port_range {
    from_port = 80
    to_port   = 80
  }

  port_range {
    from_port = 443
    to_port   = 443
  }
}

resource "aws_globalaccelerator_endpoint_group" "endpoint" {
  listener_arn                  = aws_globalaccelerator_listener.listener.id
  health_check_port             = 80
  health_check_protocol         = "TCP"
  health_check_interval_seconds = 30
  threshold_count               = 3

  endpoint_configuration {
    endpoint_id = var.endpoint_lb_arn
    weight      = 128
  }
}