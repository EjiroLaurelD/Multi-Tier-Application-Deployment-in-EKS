data "aws_route53_zone" "domain" {
  name = var.domain
}

locals {
  loadbalancer_svc_name = "${var.controller-full-name}-${var.controller-name}"
}

resource "null_resource" "get_nlb_hostname" {
  triggers = {
    svc_name = local.loadbalancer_svc_name
  }

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name '${var.cluster_name}' --region ${var.region} && kubectl get svc '${self.triggers.svc_name}' -n '${kubernetes_namespace.nginx-controller.metadata[0].name}' -o jsonpath='{.status.loadBalancer.ingress[*].hostname}' > ${path.module}/nlb_hostname.txt"
  }

  depends_on = [helm_release.ingress]
}

data "local_file" "nlb_hostname" {
  filename = "${path.module}/nlb_hostname.txt"
  depends_on = [null_resource.get_nlb_hostname]
}

resource "aws_route53_record" "ingress-lb" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "*.${var.domain}"
  type    = "CNAME"
  ttl     = "300"
  records = [data.local_file.nlb_hostname.content]

  depends_on = [data.local_file.nlb_hostname]
}
