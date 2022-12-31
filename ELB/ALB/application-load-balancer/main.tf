# ----------------------------------------------------------------------------------------------------
# ---------------------------------- APPLICATION LOAD BALANCER V1 ------------------------------------
# ----------------------------- LISTENER 80 & 443, TARGET GROUP 443 ----------------------------------
# ----------------------------------------------------------------------------------------------------

# Application Load Balancer
resource "aws_lb" "alb" {
  name                       = var.alb_name
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = var.security_groups
  subnets                    = var.subnets
  enable_http2               = true
  enable_deletion_protection = var.enable_deletion_protection
  drop_invalid_header_fields = var.drop_invalid_header_fields

  access_logs {
    bucket  = var.access_logs_bucket
    prefix  = var.access_logs_prefix
    enabled = var.access_logs_enabled
  }

  tags = {
    #Name          = var.alb_name   AWS Tag Policy no permite asignar tag Name desde terraform.
    "Cost Center" = var.cost_center
    Stack         = var.stack
    Creator       = var.creator
  }
}

# ALB Listener Port 80
resource "aws_lb_listener" "listener_80" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.listener_80_port
  protocol          = var.listener_80_protocol

  default_action {
    type = "redirect"

    redirect {
      port        = var.listener_80_redirect_port
      protocol    = var.listener_80_redirect_protocol
      status_code = var.listener_80_redirect_status_code
    }
  }
}

# ALB Listener Port 443
resource "aws_lb_listener" "listener_443" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.listener_443_port
  protocol          = var.listener_443_protocol
  ssl_policy        = var.listener_443_ssl_policy
  certificate_arn   = var.listener_443_certificate_arn
  #certificate_arn   = "arn:aws:acm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:certificate/${var.certificate_arn_suffix}"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_443.arn
  }
}

# Target Group Port 443
resource "aws_lb_target_group" "tg_443" {
  name        = var.alb_target_group_443_name
  port        = 443
  protocol    = "HTTPS"
  vpc_id      = var.vpc_id
  target_type = "instance"
  load_balancing_algorithm_type = "least_outstanding_requests"

  health_check {
    path                = var.healthcheck_path
    healthy_threshold   = 2
    unhealthy_threshold = 2
    port                = "traffic-port"
    protocol            = "HTTPS"
    interval            = var.interval
  }

  tags = {
    "Cost Center" = var.cost_center
    Stack         = var.stack
    Creator       = var.creator
  }
}

/*
# Target Group Port 80
resource "aws_lb_target_group" "tg_80" {
  name        = var.alb_target_group_80_name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
  health_check {
    path                = var.healthcheck_path
    healthy_threshold   = 2
    unhealthy_threshold = 2
    port                = "traffic-port"
  }
}
*/


# ------------------------------------------- Data Sources -------------------------------------------

# Account information
data "aws_caller_identity" "current" {}
# "account_id" data.aws_caller_identity.current.account_id
# "caller_arn" data.aws_caller_identity.current.arn
# "caller_user" data.aws_caller_identity.current.user_id

# Current Region
data "aws_region" "current" {}