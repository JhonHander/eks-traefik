#!/bin/bash
# Script para instalar Traefik como Ingress Controller en EKS

echo "==================================="
echo "Instalando Traefik en EKS"
echo "==================================="

# Agregar el repositorio Helm de Traefik
echo "Agregando repositorio Helm de Traefik..."
helm repo add traefik https://traefik.github.io/charts
helm repo update

# Crear namespace para Traefik
echo "Creando namespace traefik..."
kubectl create namespace traefik --dry-run=client -o yaml | kubectl apply -f -

# Instalar Traefik usando Helm
echo "Instalando Traefik..."
helm install traefik traefik/traefik \
  --namespace traefik \
  --values traefik-values.yaml \
  --wait

echo ""
echo "==================================="
echo "Verificando la instalación..."
echo "==================================="

# Verificar pods
kubectl get pods -n traefik

echo ""
echo "Esperando a que el Load Balancer esté listo..."
echo "Esto puede tardar unos minutos..."
sleep 30

# Obtener la URL del Load Balancer
echo ""
echo "==================================="
echo "Información del Load Balancer:"
echo "==================================="
kubectl get svc -n traefik

echo ""
echo "Para obtener la URL del Load Balancer ejecuta:"
echo "kubectl get svc traefik -n traefik -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'"

echo ""
echo "¡Instalación completada!"
