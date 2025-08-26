variable  "aws_region" {
  type        = string
  description = "Región AWS donde se desplegará la infraestructura."
  default     = "us-east-1"
}


variable "aws_profile" {
  type        = string
  description = "Perfil AWS a utilizar."
  default     = "default"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block para la VPC."
  default     = "10.0.0.0/16"
}