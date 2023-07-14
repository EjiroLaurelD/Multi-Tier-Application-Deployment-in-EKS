locals {
  default_ssl = "${kubernetes_namespace.cert_manager_ns.metadata[0].name}/${var.wildcard_secret_name}" 
}

resource "kubernetes_namespace" "nginx-controller" {
  metadata {
    name = "nginx-controller"
  }
}

resource "helm_release" "ingress" {
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart = "ingress-nginx"
  name = "nginx-ingress"
  version = "4.5.2"
  timeout = 1000
  namespace = kubernetes_namespace.nginx-controller.metadata[0].name
  values = ["${file("nginx-controller-values.yaml")}"]

  set {
    name = "fullnameOverride"
    value = var.controller-full-name
  }

  set {
    name = "controller.name"
    value = var.controller-name
  }

  set {
    name = "controller.extraArgs.default-ssl-certificate"
    value = local.default_ssl
  }

  depends_on = [module.eks, kubectl_manifest.letsencrypt, kubernetes_namespace.nginx-controller]
}

data "kubernetes_service" "nginx_ingress" {
  metadata {
    name = "ingress-controller"
    namespace = kubernetes_namespace.nginx-controller.metadata[0].name
  }

  depends_on = [helm_release.ingress]
}
