output "name" {
  description = "Name of the Global Accelerator."
  value       = aws_globalaccelerator_accelerator.global_accelerator.name
}

output "dns_name" {
  description = "DNS name of the Global Accelerator."
  value       = aws_globalaccelerator_accelerator.global_accelerator.dns_name
}

output "hosted_zone_id" {
  description = "obtiene el Host ID del global accelerator"
  value       = aws_globalaccelerator_accelerator.global_accelerator.hosted_zone_id
}
