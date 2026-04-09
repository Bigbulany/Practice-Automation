variable "rules" {
  type = list(object({
    host        = string
    service_name = string
    service_port = number
  }))
}

resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name = "my-ingress"
  }

  spec {
    ingress_class_name = "nginx"

    dynamic "rule" {
      for_each = var.rules

      content {
        host = rule.value.host

        http {
          path {
            path      = "/"
            path_type = "Prefix"

            backend {
              service {
                name = rule.value.service_name

                port {
                  number = rule.value.service_port
                }
              }
            }
          }
        }
      }
    }
  }
}