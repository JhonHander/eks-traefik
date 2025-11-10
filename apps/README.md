# Directorio de Aplicaciones Docker

Este directorio contiene el código fuente de las aplicaciones que se construyen como imágenes Docker.

## Estructura

```
apps/
├── app1/
│   ├── Dockerfile      # Dockerfile para App1
│   └── index.html      # HTML de App1
└── app2/
    ├── Dockerfile      # Dockerfile para App2
    └── index.html      # HTML de App2
```

## Cómo construir las imágenes

Ver los scripts en `/scripts`:
- `build-and-push.sh` (Linux/Mac)
- `build-and-push.bat` (Windows)

## Modificar las aplicaciones

1. Edita el `index.html` de la app que quieras modificar
2. Ejecuta el script de build and push
3. Actualiza el deployment en Kubernetes si cambiaste la versión
