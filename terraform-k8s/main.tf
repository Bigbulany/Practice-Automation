provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_deployment_v1" "dev_app" {
  metadata {
    name = "dev-my-app"
    labels = {
      app = "my-app"
      env = "dev"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "my-app"
        env = "dev"
      }
    }

    template {
      metadata {
        labels = {
          app = "my-app"
          env = "dev"
        }
      }

      spec {
        container {
          name  = "my-container"
          image = "valdevops7/my-first-app:24"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment_v1" "prod_app" {
  metadata {
    name = "prod-my-app"
    labels = {
      app = "my-app"
      env = "prod"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "my-app"
        env = "prod"
      }
    }

    template {
      metadata {
        labels = {
          app = "my-app"
          env = "prod"
        }
      }

      spec {
        container {
          name  = "my-container"
          image = "valdevops7/my-first-app:24"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "dev_service" {
  metadata {
    name = "dev-service"
  }

  spec {
    selector = {
      app = "my-app"
      env = "dev"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}

resource "kubernetes_service_v1" "prod_service" {
  metadata {
    name = "prod-service"
  }

  spec {
    selector = {
      app = "my-app"
      env = "prod"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}


resource "kubernetes_ingress_v1" "my_ingress" {
  metadata {
    name = "my-ingress"
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      host = "dev.myapp.local"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service_v1.dev_service.metadata[0].name

              port {
                number = 80
              }
            }
          }
        }
      }
    }

    rule {
      host = "prod.myapp.local"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service_v1.prod_service.metadata[0].name

              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}


