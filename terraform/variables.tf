variable "aws_region" {
  description = "AWS region donde se desplegará el cluster EKS"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Nombre del ambiente"
  type        = string
  default     = "lab"
}

variable "cluster_name" {
  description = "Nombre del cluster EKS"
  type        = string
  default     = "eks-traefik-lab"
}

variable "kubernetes_version" {
  description = "Versión de Kubernetes para EKS"
  type        = string
  default     = "1.31"
}

variable "vpc_cidr" {
  description = "CIDR block para la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "node_instance_types" {
  description = "Tipos de instancias para los nodos de EKS"
  type        = list(string)
  default     = ["t3.small"]
}

variable "node_desired_size" {
  description = "Número deseado de nodos"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Número mínimo de nodos"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Número máximo de nodos"
  type        = number
  default     = 3
}
