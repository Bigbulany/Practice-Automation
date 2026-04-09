variable "app_name" {}
variable "env" {}
variable "image" {}

resource "kubernetes_deployment_v1" "app" {
  metadata {
    name = "${var.env}-${var.app_name}"
    labels = {
      app = var.app_name
      env = var.env
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.app_name
        env = var.env
      }
    }

    template {
      metadata {
        labels = {
          app = var.app_name
          env = var.env
        }
      }

      spec {
        container {
          name  = "my-container"
          image = var.image

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "app_service" {
  metadata {
    name = "${var.env}-service"
  }

  spec {
    selector = {
      app = var.app_name
      env = var.env
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}

output "service_name" {
  value = kubernetes_service_v1.app_service.metadata[0].name
}