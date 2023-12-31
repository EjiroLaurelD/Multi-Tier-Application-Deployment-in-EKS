module "nginx-controller" {
  source = "terraform-iaac/nginx-controller/helm"
  additional_set = [
    {
      name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
      value = "nlb"
      type  = "string"
    },
    {
      name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-cross-zone-load-balancing-enabled"
      value = "true"
      type  = "string"
    },
    {
       name = "fullnameOverride"
       value = "controller"
     },
     {
       name = "controller.name"
       value = "controller"
     }
  ]
  depends_on = [module.eks, helm_release.cert-manager]

}
#resource "null_resource" "get_nlb_hostname" {
 # provisioner "local-exec" {
  #  command = "aws eks update-kubeconfig --name myappsv --region ${var.region} && kubectl get svc fullnameOverridevalue-controller.namevalue -n '${module.nginx-controller.kubernetes_namespace.metadata[0].name}' -o jsonpath='{.status.loadBalancer.ingress[*].hostname}' > ${path.module}/lb_hostname.txt"
 # }
#}
