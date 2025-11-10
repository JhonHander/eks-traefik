output "cluster_id" {
  description = "ID del cluster EKS"
  value       = aws_eks_cluster.main.id
}

output "cluster_name" {
  description = "Nombre del cluster EKS"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "Endpoint del cluster EKS"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_security_group_id" {
  description = "ID del security group del cluster"
  value       = aws_security_group.eks_cluster.id
}

output "vpc_id" {
  description = "ID de la VPC"
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "IDs de las subnets públicas"
  value       = aws_subnet.public[*].id
}

output "configure_kubectl" {
  description = "Comando para configurar kubectl"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${aws_eks_cluster.main.name}"
}

output "region" {
  description = "Región de AWS"
  value       = var.aws_region
}

output "ecr_app1_repository_url" {
  description = "URL del repositorio ECR para App1"
  value       = aws_ecr_repository.app1.repository_url
}

output "ecr_app2_repository_url" {
  description = "URL del repositorio ECR para App2"
  value       = aws_ecr_repository.app2.repository_url
}

output "ecr_login_command" {
  description = "Comando para hacer login en ECR"
  value       = "aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
}

# Data source para obtener el account ID
data "aws_caller_identity" "current" {}
