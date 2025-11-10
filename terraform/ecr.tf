# ECR Repositories para las aplicaciones

# Repositorio para App1
resource "aws_ecr_repository" "app1" {
  name                 = "${var.cluster_name}-app1"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "${var.cluster_name}-app1"
    Application = "app1"
  }
}

# Repositorio para App2
resource "aws_ecr_repository" "app2" {
  name                 = "${var.cluster_name}-app2"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "${var.cluster_name}-app2"
    Application = "app2"
  }
}

# Lifecycle policy para App1 - mantener solo las últimas 5 imágenes
resource "aws_ecr_lifecycle_policy" "app1" {
  repository = aws_ecr_repository.app1.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 5 images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 5
      }
      action = {
        type = "expire"
      }
    }]
  })
}

# Lifecycle policy para App2 - mantener solo las últimas 5 imágenes
resource "aws_ecr_lifecycle_policy" "app2" {
  repository = aws_ecr_repository.app2.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 5 images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 5
      }
      action = {
        type = "expire"
      }
    }]
  })
}
