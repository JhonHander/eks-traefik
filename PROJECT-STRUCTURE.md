# 📁 Estructura del Proyecto EKS-Traefik

```
eks-traefik/
│
├── 📄 README.md                      # Guía rápida Docker + ECR
├── 📄 COMMANDS.md                    # Comandos para construir y destruir
├── 📄 FULL-GUIDE.md                  # Guía completa detallada
│
├── � apps/                          # Aplicaciones Docker
│   ├── app1/
│   │   ├── Dockerfile                # Imagen nginx con HTML personalizado
│   │   └── index.html                # App con tema morado
│   └── app2/
│       ├── Dockerfile                # Imagen nginx con HTML personalizado
│       └── index.html                # App con tema rosa
│
├── 📂 terraform/                     # Infraestructura AWS
│   ├── provider.tf                   # Configuración AWS
│   ├── variables.tf                  # Variables del proyecto
│   ├── vpc.tf                        # VPC con subnets públicas
│   ├── eks.tf                        # Cluster EKS + nodos
│   ├── ecr.tf                        # Repositorios ECR
│   └── outputs.tf                    # URLs y comandos útiles
│
├── 📂 scripts/                       # Automatización
│   ├── build-and-push.bat/sh         # Construir y subir imágenes a ECR
│   ├── update-manifests.bat/sh       # Actualizar manifiestos con URLs ECR
│   ├── install-traefik.bat/sh        # Instalar Traefik en EKS
│   └── traefik-values.yaml           # Configuración Traefik
│
└── 📂 kubernetes/                    # Manifiestos K8s
    ├── app1.yaml                     # Deployment + Service App1
    ├── app2.yaml                     # Deployment + Service App2
    └── ingress.yaml                  # Ingress con rutas /app1 y /app2
```

## 🏗️ Recursos que se Crean

### En AWS (Terraform)
- ✅ 1 VPC (10.0.0.0/16)
- ✅ 2 Subnets públicas
- ✅ 1 Internet Gateway
- ✅ 1 Cluster EKS
- ✅ 2 Nodos EC2 t3.small
- ✅ 2 Repositorios ECR (para imágenes Docker)
- ✅ 1 Network Load Balancer (creado por Traefik)

### En Kubernetes
- ✅ Traefik Ingress Controller
- ✅ 2 Deployments (app1, app2) con 2 réplicas cada uno
- ✅ 2 Services ClusterIP
- ✅ 1 Ingress con rutas /app1 y /app2
- ✅ 1 Middleware (strip-prefix)

## 🌐 Arquitectura de Red

```
Internet
   ↓
┌────────────────────────────────────────────────────────┐
│                      AWS VPC                           │
│                   (10.0.0.0/16)                        │
│                                                         │
│                 Internet Gateway                        │
│                        ↓                                │
│   ┌──────────────────────────┬─────────────────────┐  │
│   ↓                          ↓                     │  │
│ Public Subnet 1          Public Subnet 2           │  │
│ (10.0.0.0/24)            (10.0.1.0/24)             │  │
│                                                     │  │
│ • EKS Worker Node        • EKS Worker Node         │  │
│ • Traefik Pod            • Traefik Pod             │  │
│ • App Pods               • App Pods                │  │
│                                                     │  │
│         Network Load Balancer (NLB)                │  │
│         ↓                                          │  │
└─────────┼───────────────────────────────────────────┘  │
          ↓                                               │
     Traefik Ingress Controller                          │
          ↓                                               │
    ┌─────┴─────┐                                        │
    ↓           ↓                                         │
  App1        App2                                        │
```

## 🔄 Flujo de Tráfico (Paso a Paso)

```
1. 👤 Usuario → http://[NLB-URL]/app1
         ↓
2. 🌐 AWS Network Load Balancer (1 ÚNICO para todo)
         ↓
3. 🚦 Traefik Ingress Controller (Lee reglas del Ingress)
         ↓
4. 🔀 Middleware strip-prefix (Quita /app1 del path)
         ↓
5. 📡 app1-service (ClusterIP - IP interna única: ej: 10.100.200.50)
         ↓
6. 📦 Kubernetes balancea entre 2 réplicas:
         ├─→ App1 Pod 1 (réplica 1)
         └─→ App1 Pod 2 (réplica 2)
         ↓
7. ✅ Respuesta HTML (desde imagen Docker en ECR)
```

## 🎨 Componentes de Kubernetes

```
Namespace: traefik
└── Traefik Ingress Controller
    └── Service (LoadBalancer) → Crea NLB en AWS

Namespace: default
├── App1
│   ├── Deployment (2 réplicas)
│   │   ├── Pod 1 → Image: ECR app1:latest
│   │   └── Pod 2 → Image: ECR app1:latest
│   └── Service (ClusterIP)
│
├── App2
│   ├── Deployment (2 réplicas)
│   │   ├── Pod 1 → Image: ECR app2:latest
│   │   └── Pod 2 → Image: ECR app2:latest
│   └── Service (ClusterIP)
│
└── Ingress
    ├── /app1 → app1-service
    └── /app2 → app2-service
```

## 🚀 Flujo de Trabajo Completo

```
1️⃣ DESARROLLO
   ┌─────────────────┐
   │ apps/app1/      │
   │ apps/app2/      │ ← Editas HTML y Dockerfile
   └─────────────────┘

2️⃣ INFRAESTRUCTURA
   ┌─────────────────┐
   │ terraform/      │
   │ terraform apply │ ← Crea VPC, EKS, ECR
   └─────────────────┘

3️⃣ BUILD & PUSH
   ┌─────────────────┐
   │ scripts/        │
   │ build-and-push  │ ← Sube imágenes a ECR
   └─────────────────┘

4️⃣ DEPLOY
   ┌─────────────────┐
   │ kubernetes/     │
   │ kubectl apply   │ ← Despliega apps en EKS
   └─────────────────┘

5️⃣ ACCESO
   ┌─────────────────┐
   │ http://NLB/app1 │
   │ http://NLB/app2 │ ← Usuarios acceden
   └─────────────────┘
```

## 💡 Conceptos Clave

| Concepto | Explicación |
|----------|-------------|
| **VPC** | Red privada en AWS donde vive todo |
| **EKS** | Kubernetes administrado por AWS |
| **ECR** | Registro de imágenes Docker de AWS |
| **Traefik** | Ingress Controller que enruta tráfico |
| **NLB** | Load Balancer de capa 4 (TCP) |
| **ClusterIP** | IP interna, no accesible desde Internet |
| **Ingress** | Reglas de routing HTTP |

## 📊 Costos Aproximados

- 💰 **EKS Control Plane**: $72/mes ($0.10/hora)
- 💰 **2x EC2 t3.small**: $30/mes
- 💰 **Network Load Balancer**: $16/mes
- 💰 **ECR Storage**: ~$0.10/mes
- 💰 **TOTAL**: ~$125/mes (~$4.17/día)

---

**📚 Lee `COMMANDS.md` para construir y destruir el laboratorio**
