resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "monitoring" {
  name = "monitoring"
  namespace = kubernetes_namespace.monitoring.metadata[0].name
  version = "45.7.1"
  chart = "kube-prometheus-stack"
  timeout = 1000
  repository = "https://prometheus-community.github.io/helm-charts"
 
  values = [templatefile("prometheus-values.yaml", {slack = "${var.prometheusslack}", graf = "${var.grafana_domain}", prom = "${var.prom_domain}", wildcard ="*.${var.domain}" }
  
  )]
}

data "kubectl_file_documents" "dashboards" {
    content = file("cloudgen-analytics-dash.yaml")
}

resource "kubectl_manifest" "cloudgen-dashboard" {
  for_each  = data.kubectl_file_documents.dashboards.manifests
  yaml_body = each.value
}

