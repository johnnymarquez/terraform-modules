output "eventbridge_rule_arn" {
    value = aws_cloudwatch_event_rule.rule.arn
}