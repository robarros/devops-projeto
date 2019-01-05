provider "kubernetes" {}

resource "kubernetes_pod" "nginx" {
  metadata {
    name = "nginx-example"
    labels {
      App = "nginx"
    }
  }
  spec {
    container {
      image = "nginx:alpine"
      name  = "nginx"
      port {
        container_port = 80
      }
    }
  }
}