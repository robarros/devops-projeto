provider "kubernetes" {
  host = "https://10.0.0.230:6443"
  username = "jenkins"
  client_key = "eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImplbmtpbnMtdG9rZW4tZG14OWgiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiamVua2lucyIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6ImExYjNlNDY4LTEwNjYtMTFlOS1hZjZkLTAwMGMyOWJhM2MwZCIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDpkZWZhdWx0OmplbmtpbnMifQ.aO85WBQhNhsHNNubGYcu2p4xUXnaY6ctHPNCRaxqU7OXHUJ-pqQ-UhuKj9bGrf7bxnlS_d7oCyZejHPpQyg0BUzApNOlNrO9p0SHGpZTim5ecHSSgXJAvgjBPLbAfClh36ihECjFozCXueR9zQxRhw9cdLfrHp2QJw_mlNDQgpAxG7A4uzywwYddGJqYDamtjKBwbtKoQiaqQCYUpU-oe06-eAToV3KvWTjc6P0F2d9yDY9f6YXl_pG_RylkTr0xGtQ9Q4ETBYkFKADl1yO9vMuv1xS2CH_S6pBjPmM-dVkvvhKqpcGyqQ5KQ2jLmcsvptVt5BXwlI6DAh0vWCqmpQ"
}

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