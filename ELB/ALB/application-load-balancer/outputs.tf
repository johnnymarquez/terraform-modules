output "alb_arn" {
  value = aws_lb.alb.arn
}

output "alb_arn_suffix" {
  value = aws_lb.alb.arn_suffix
}

output "tg_443_arn_suffix" {
  value = aws_lb_target_group.tg_443.arn_suffix
}

output "tg_443_arn" {
  value = aws_lb_target_group.tg_443.arn
}

output "dns_name" {
  value = aws_lb.alb.dns_name
}

output "zone_id" {
  value = aws_lb.alb.zone_id
}

output "alb_name" {
  value = aws_lb.alb.name
}