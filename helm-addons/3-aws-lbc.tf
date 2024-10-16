data "aws_iam_policy_document" "aws_lbc" {
  count = var.aws_lbc.enable ? 1 : 0
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

resource "aws_iam_role" "aws_lbc" {
  count = var.aws_lbc.enable ? 1 : 0

  name               = "${var.eks_name}-aws-lbc"
  assume_role_policy = data.aws_iam_policy_document.aws_lbc[0].json
}

resource "aws_iam_policy" "aws_lbc" {
  count = var.aws_lbc.enable ? 1 : 0

  policy = file("${path.module}/policy/AWSLoadBalancerController.json")
  name   = "AWSLoadBalancerController"
}

resource "aws_iam_role_policy_attachment" "aws_lbc" {
  count = var.aws_lbc.enable ? 1 : 0

  policy_arn = aws_iam_policy.aws_lbc[0].arn
  role       = aws_iam_role.aws_lbc[0].name
}

resource "aws_eks_pod_identity_association" "aws_lbc" {
  count = var.aws_lbc.enable ? 1 : 0

  cluster_name    = var.eks_name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
  role_arn        = aws_iam_role.aws_lbc[0].arn
}

resource "helm_release" "aws_lbc" {
  count = var.aws_lbc.enable ? 1 : 0
  
  name = "${var.env}-${var.eks_name}-aws-load-balancer-controller"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = var.aws_lbc.helm_chart_version
  values = [file(var.aws_lbc.path_to_values_file)]

  set {
    name  = "clusterName"
    value = var.eks_name
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  depends_on = [helm_release.cluster_autoscaler]
}
