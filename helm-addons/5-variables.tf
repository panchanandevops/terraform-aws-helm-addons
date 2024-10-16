variable "env" {
  description = "Environment name."
  type        = string
}

variable "eks_name" {
  description = "Name of the cluster."
  type        = string
}

variable "cluster_autoscaler" {
  description = "Defines all the parameters for Cluster Autoscaler"
  type        = map(any)
  default = {
    enable              = true
    region              = "us-east-1"
    helm_chart_version  = "9.37.0"
    path_to_values_file = "${path.module}/values/cluster_autoscaler.yaml"
  }
}

variable "metrics_server" {
  description = "Defines all the parameters for metrics server"
  type        = map(any)
  default = {
    enable              = true
    helm_chart_version  = "3.12.1"
    path_to_values_file = "${path.module}/values/metrics_server.yaml"
  }
}

variable "aws_lbc" {
  description = "Defines all the parameters for AWS LoadBalancer Controller"
  type        = map(any)
  default = {
      enable              = true
      helm_chart_version  = "1.7.2"
      path_to_values_file = "${path.module}/values/aws_lbc.yaml"
    }
}

variable "external_nginx_ingress_controller" {
  description = "Defines all the parameters for Nginx Ingress Controller"
  type        = map(any)
  default = {
    enable              = true
    helm_chart_version  = "4.10.1"
    path_to_values_file = "${path.module}/values/nginx_ingress_controller.yaml"
  }
}
