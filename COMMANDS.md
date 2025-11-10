# Comandos - Laboratorio EKS con Traefik

## 🚀 CONSTRUIR TODO (Paso a Paso)

### **Paso 1: Crear Infraestructura AWS (EKS, VPC, ECR)**
```bash
cd terraform
terraform init
terraform apply
```
⏱️ *Tiempo estimado: 15-20 minutos*

### **Paso 2: Configurar kubectl**
```bash
aws eks update-kubeconfig --region us-east-1 --name eks-traefik-lab
kubectl get nodes
```

### **Paso 3: Construir y Subir Imágenes Docker a ECR**

**Windows:**
```cmd
cd ..\scripts
build-and-push.bat
```

**Linux/Mac:**
```bash
cd ../scripts
chmod +x build-and-push.sh
./build-and-push.sh
```
⏱️ *Tiempo estimado: 2-5 minutos*

### **Paso 4: Actualizar Manifiestos con URLs de ECR**

**Windows:**
```cmd
update-manifests.bat
```

**Linux/Mac:**
```bash
chmod +x update-manifests.sh
./update-manifests.sh
```

### **Paso 5: Instalar Traefik Ingress Controller**

**Windows:**
```cmd
install-traefik.bat
```

**Linux/Mac:**
```bash
chmod +x install-traefik.sh
./install-traefik.sh
```
⏱️ *Tiempo estimado: 2-3 minutos*

### **Paso 6: Desplegar Aplicaciones**
```bash
cd ..\kubernetes
kubectl apply -f app1.yaml
kubectl apply -f app2.yaml
kubectl apply -f ingress.yaml
```

### **Paso 7: Obtener URL del Load Balancer**
```bash
kubectl get svc traefik -n traefik
```

Copia el valor de `EXTERNAL-IP` y accede a:
- **App1:** http://EXTERNAL-IP/app1
- **App2:** http://EXTERNAL-IP/app2

---

## 🗑️ DESTRUIR TODO (Antes de Apagar)

> ⚠️ **IMPORTANTE**: Sigue estos pasos EN ORDEN para evitar costos adicionales y problemas al destruir.

### **Paso 1: Eliminar Aplicaciones y Ingress**
```bash
cd kubernetes
kubectl delete -f ingress.yaml
kubectl delete -f app2.yaml
kubectl delete -f app1.yaml
```

### **Paso 2: Desinstalar Traefik**
```bash
helm uninstall traefik -n traefik
kubectl delete namespace traefik
```
⏱️ *Espera 2-3 minutos para que AWS elimine el Load Balancer*

### **Paso 3: Verificar que el Load Balancer se eliminó**
```bash
kubectl get svc -A
```
✅ *No debe aparecer ningún servicio tipo LoadBalancer*

### **Paso 4: Destruir Infraestructura con Terraform**
```bash
cd ..\terraform
terraform destroy
```
⏱️ *Tiempo estimado: 10-15 minutos*

**Confirma escribiendo:** `yes`

---

## 📊 Comandos de Verificación Rápida

### Ver estado del cluster
```bash
kubectl get nodes
kubectl get pods -A
kubectl get svc -A
```

### Ver logs de las aplicaciones
```bash
kubectl logs -l app=app1 --tail=20
kubectl logs -l app=app2 --tail=20
```

### Ver logs de Traefik
```bash
kubectl logs -n traefik -l app.kubernetes.io/name=traefik --tail=50
```

---

## 💰 Estimación de Costos

- **Mientras está encendido**: ~$4.17/día (~$125/mes)
- **Componentes principales**:
  - EKS Control Plane: $0.10/hora ($72/mes)
  - 2x EC2 t3.small: $0.0208/hora cada uno (~$30/mes)
  - Network Load Balancer: ~$0.0225/hora (~$16/mes)
  - Transferencia de datos: Variable

---

## 🎓 Para tu Clase

### Antes de la clase:
```bash
# Ejecutar CONSTRUIR TODO (Pasos 1-7)
# Tiempo total: ~25-30 minutos
```

### Durante la clase:
- Accede a las URLs y demuestra el funcionamiento
- Muestra los comandos de verificación
- Explica la arquitectura (VPC, EKS, Traefik, Ingress)

### Después de la clase:
```bash
# Ejecutar DESTRUIR TODO (Pasos 1-4)
# Tiempo total: ~15-20 minutos
```

---

## 🔧 Troubleshooting Rápido

### Si `terraform destroy` falla:
```bash
# 1. Asegúrate de haber eliminado el Load Balancer primero
kubectl get svc -A

# 2. Si hay servicios LoadBalancer, elimínalos:
kubectl delete svc traefik -n traefik

# 3. Espera 3 minutos y reintenta:
terraform destroy
```

### Si no puedes conectarte al cluster:
```bash
aws eks update-kubeconfig --region us-east-1 --name eks-traefik-lab
kubectl get nodes
```

### Si las imágenes no suben a ECR:
```bash
# Verifica que Docker esté corriendo
docker ps

# Verifica credenciales AWS
aws sts get-caller-identity
```
