output "vpc_id" {
  description = "ID de la VPC creada."
  value       =  aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR de la VPC creada."
  value       =  aws_vpc.main.cidr_block
}

output "region" {
    description = "Región AWS utilizada por el provider."
    value       = var.aws_region    
}