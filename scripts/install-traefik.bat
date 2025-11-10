@echo off
REM Script para instalar Traefik como Ingress Controller en EKS (Windows)

echo ===================================
echo Instalando Traefik en EKS
echo ===================================

REM Agregar el repositorio Helm de Traefik
echo Agregando repositorio Helm de Traefik...
helm repo add traefik https://traefik.github.io/charts
helm repo update

REM Crear namespace para Traefik
echo Creando namespace traefik...
kubectl create namespace traefik --dry-run=client -o yaml | kubectl apply -f -

REM Instalar Traefik usando Helm
echo Instalando Traefik...
helm install traefik traefik/traefik --namespace traefik --values traefik-values.yaml --wait

echo.
echo ===================================
echo Verificando la instalacion...
echo ===================================

REM Verificar pods
kubectl get pods -n traefik

echo.
echo Esperando a que el Load Balancer este listo...
echo Esto puede tardar unos minutos...
timeout /t 30 /nobreak >nul

REM Obtener informacion del servicio
echo.
echo ===================================
echo Informacion del Load Balancer:
echo ===================================
kubectl get svc -n traefik

echo.
echo Para obtener la URL del Load Balancer ejecuta:
echo kubectl get svc traefik -n traefik -o jsonpath="{.status.loadBalancer.ingress[0].hostname}"

echo.
echo Instalacion completada!
pause
