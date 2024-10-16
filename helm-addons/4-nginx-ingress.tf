resource "helm_release" "external_nginx" {
  count = var.external_nginx_ingress_controller.enable ? 1 : 0
  
  name = "${var.env}-${var.eks_name}-extenal"

  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress"
  create_namespace = true
  version          = var.external_nginx_ingress_controller.helm_chart_version

  values = [file(var.external_nginx_ingress_controller.path_to_values_file)]

  depends_on = [helm_release.aws_lbc]
}