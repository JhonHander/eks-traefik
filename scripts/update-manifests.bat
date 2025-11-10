@echo off
REM Script para actualizar los manifiestos de Kubernetes con las URLs de ECR

echo ===================================
echo Actualizando manifiestos de K8s con URLs de ECR
echo ===================================

REM Obtener las URLs de ECR desde Terraform
cd ..\terraform
for /f "delims=" %%i in ('terraform output -raw ecr_app1_repository_url') do set ECR_APP1=%%i
for /f "delims=" %%i in ('terraform output -raw ecr_app2_repository_url') do set ECR_APP2=%%i
cd ..\scripts

echo App1 ECR: %ECR_APP1%
echo App2 ECR: %ECR_APP2%
echo.

REM Crear app1.yaml
(
echo apiVersion: apps/v1
echo kind: Deployment
echo metadata:
echo   name: app1
echo   namespace: default
echo   labels:
echo     app: app1
echo spec:
echo   replicas: 2
echo   selector:
echo     matchLabels:
echo       app: app1
echo   template:
echo     metadata:
echo       labels:
echo         app: app1
echo     spec:
echo       containers:
echo       - name: app1
echo         image: %ECR_APP1%:latest
echo         ports:
echo         - containerPort: 80
echo         resources:
echo           requests:
echo             cpu: 100m
echo             memory: 128Mi
echo           limits:
echo             cpu: 200m
echo             memory: 256Mi
echo ---
echo apiVersion: v1
echo kind: Service
echo metadata:
echo   name: app1-service
echo   namespace: default
echo spec:
echo   type: ClusterIP
echo   selector:
echo     app: app1
echo   ports:
echo   - protocol: TCP
echo     port: 80
echo     targetPort: 80
) > ..\kubernetes\app1.yaml

REM Crear app2.yaml
(
echo apiVersion: apps/v1
echo kind: Deployment
echo metadata:
echo   name: app2
echo   namespace: default
echo   labels:
echo     app: app2
echo spec:
echo   replicas: 2
echo   selector:
echo     matchLabels:
echo       app: app2
echo   template:
echo     metadata:
echo       labels:
echo         app: app2
echo     spec:
echo       containers:
echo       - name: app2
echo         image: %ECR_APP2%:latest
echo         ports:
echo         - containerPort: 80
echo         resources:
echo           requests:
echo             cpu: 100m
echo             memory: 128Mi
echo           limits:
echo             cpu: 200m
echo             memory: 256Mi
echo ---
echo apiVersion: v1
echo kind: Service
echo metadata:
echo   name: app2-service
echo   namespace: default
echo spec:
echo   type: ClusterIP
echo   selector:
echo     app: app2
echo   ports:
echo   - protocol: TCP
echo     port: 80
echo     targetPort: 80
) > ..\kubernetes\app2.yaml

echo Manifiestos actualizados:
echo    - ..\kubernetes\app1.yaml
echo    - ..\kubernetes\app2.yaml
echo.
echo Ahora puedes desplegar con:
echo    kubectl apply -f ..\kubernetes\app1.yaml
echo    kubectl apply -f ..\kubernetes\app2.yaml
echo    kubectl apply -f ..\kubernetes\ingress.yaml
pause
