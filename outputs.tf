# output "vpc_id" {
#   description = "ID de la VPC creada."
#   value       =  aws_vpc.main.id
# }

# output "vpc_cidr" {
#   description = "CIDR de la VPC creada."
#   value       =  aws_vpc.main.cidr_block
# }

output "region" {
    description = "Región AWS utilizada por el provider."
    value       = var.aws_region    
}

output "instance_id" {
    description = "ID de la instancia EC2 creada."
    value       = aws_instance.server.id
}

output "public_ip" {
    description = "Dirección IP pública de la instancia EC2."
    value       = aws_instance.server.public_ip
}