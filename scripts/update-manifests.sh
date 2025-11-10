#!/bin/bash
# Script para actualizar los manifiestos de Kubernetes con las URLs de ECR

set -e

echo "==================================="
echo "Actualizando manifiestos de K8s con URLs de ECR"
echo "==================================="

# Obtener las URLs de ECR desde Terraform
cd ../terraform
ECR_APP1=$(terraform output -raw ecr_app1_repository_url)
ECR_APP2=$(terraform output -raw ecr_app2_repository_url)
cd ../scripts

echo "App1 ECR: $ECR_APP1"
echo "App2 ECR: $ECR_APP2"
echo ""

# Crear versiones actualizadas de los manifiestos
cat > ../kubernetes/app1.yaml << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app1
  namespace: default
  labels:
    app: app1
spec:
  replicas: 2
  selector:
    matchLabels:
      app: app1
  template:
    metadata:
      labels:
        app: app1
    spec:
      containers:
      - name: app1
        image: $ECR_APP1:latest
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 200m
            memory: 256Mi
---
apiVersion: v1
kind: Service
metadata:
  name: app1-service
  namespace: default
spec:
  type: ClusterIP
  selector:
    app: app1
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
EOF

cat > ../kubernetes/app2.yaml << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app2
  namespace: default
  labels:
    app: app2
spec:
  replicas: 2
  selector:
    matchLabels:
      app: app2
  template:
    metadata:
      labels:
        app: app2
    spec:
      containers:
      - name: app2
        image: $ECR_APP2:latest
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 200m
            memory: 256Mi
---
apiVersion: v1
kind: Service
metadata:
  name: app2-service
  namespace: default
spec:
  type: ClusterIP
  selector:
    app: app2
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
EOF

echo "✅ Manifiestos actualizados:"
echo "   - ../kubernetes/app1.yaml"
echo "   - ../kubernetes/app2.yaml"
echo ""
echo "Ahora puedes desplegar con:"
echo "   kubectl apply -f ../kubernetes/app1.yaml"
echo "   kubectl apply -f ../kubernetes/app2.yaml"
echo "   kubectl apply -f ../kubernetes/ingress.yaml"
