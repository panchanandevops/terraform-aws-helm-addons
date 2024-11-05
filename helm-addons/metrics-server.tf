resource "helm_release" "metrics_server" {
  count = var.metrics_server.enable ? 1 : 0

  name       = "${var.env}-metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"
  version    = var.metrics_server.helm_chart_version

  values = [file(var.metrics_server.path_to_values_file)]
}
