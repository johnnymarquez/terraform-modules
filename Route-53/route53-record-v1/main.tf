# ------------------------------------------------------------------------------------------------------------
# --------------------------------------- Route 53 Record with Alias -----------------------------------------
# ------------------------------------------------------------------------------------------------------------

resource "aws_route53_record" "record" {
  zone_id = ""
  name    = var.name
  type    = var.type

  alias {
    name                   = var.alias_dns_name
    zone_id                = var.alias_zone_id
    evaluate_target_health = true
  }
}
