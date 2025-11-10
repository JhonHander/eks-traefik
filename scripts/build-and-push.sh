#!/bin/bash
# Script para construir y subir las imágenes Docker a ECR

set -e

echo "==================================="
echo "Build and Push Docker Images to ECR"
echo "==================================="

# Obtener información de Terraform
echo "Obteniendo información de ECR desde Terraform..."
cd ../terraform
AWS_REGION=$(terraform output -raw region)
ECR_APP1=$(terraform output -raw ecr_app1_repository_url)
ECR_APP2=$(terraform output -raw ecr_app2_repository_url)
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
cd ../scripts

echo ""
echo "Región AWS: $AWS_REGION"
echo "Repositorio App1: $ECR_APP1"
echo "Repositorio App2: $ECR_APP2"
echo ""

# Login a ECR
echo "==================================="
echo "Autenticando con ECR..."
echo "==================================="
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Construir y subir App1
echo ""
echo "==================================="
echo "Construyendo App1..."
echo "==================================="
cd apps/app1
docker build -t eks-traefik-lab-app1:latest .
docker tag eks-traefik-lab-app1:latest $ECR_APP1:latest
docker tag eks-traefik-lab-app1:latest $ECR_APP1:v1.0.0

echo "Subiendo App1 a ECR..."
docker push $ECR_APP1:latest
docker push $ECR_APP1:v1.0.0
cd ../..

# Construir y subir App2
echo ""
echo "==================================="
echo "Construyendo App2..."
echo "==================================="
cd apps/app2
docker build -t eks-traefik-lab-app2:latest .
docker tag eks-traefik-lab-app2:latest $ECR_APP2:latest
docker tag eks-traefik-lab-app2:latest $ECR_APP2:v1.0.0

echo "Subiendo App2 a ECR..."
docker push $ECR_APP2:latest
docker push $ECR_APP2:v1.0.0
cd ../..

echo ""
echo "==================================="
echo "✅ ¡Listo!"
echo "==================================="
echo ""
echo "Imágenes construidas y subidas:"
echo "  • $ECR_APP1:latest"
echo "  • $ECR_APP1:v1.0.0"
echo "  • $ECR_APP2:latest"
echo "  • $ECR_APP2:v1.0.0"
echo ""
echo "Ahora puedes desplegar las aplicaciones en Kubernetes:"
echo "  cd kubernetes"
echo "  kubectl apply -f app1.yaml"
echo "  kubectl apply -f app2.yaml"
echo ""
