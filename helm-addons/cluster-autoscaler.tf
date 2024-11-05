resource "aws_iam_role" "cluster_autoscaler" {
  count = var.cluster_autoscaler.enable ? 1 : 0

  name = "${var.env}-${var.eks_name}-cluster-autoscaler"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "cluster_autoscaler" {
  count = var.cluster_autoscaler.enable ? 1 : 0

  name = "${var.env}-${var.eks_name}-cluster-autoscaler"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeScalingActivities",
          "autoscaling:DescribeTags",
          "ec2:DescribeImages",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeLaunchTemplateVersions",
          "ec2:GetInstanceTypesFromInstanceRequirements",
          "eks:DescribeNodegroup"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup"
        ]
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  count = var.cluster_autoscaler.enable ? 1 : 0

  policy_arn = aws_iam_policy.cluster_autoscaler[0].arn
  role       = aws_iam_role.cluster_autoscaler[0].name
}

resource "aws_eks_pod_identity_association" "cluster_autoscaler" {
  count = var.cluster_autoscaler.enable ? 1 : 0

  cluster_name    = var.eks_name
  namespace       = "kube-system"
  service_account = "cluster-autoscaler"
  role_arn        = aws_iam_role.cluster_autoscaler[0].arn
}

resource "helm_release" "cluster_autoscaler" {
  count = var.cluster_autoscaler.enable ? 1 : 0
  
  name = "${var.env}-${var.eks_name}-autoscaler"

  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"
  version    = var.cluster_autoscaler.helm_chart_version
  values = [file(var.cluster_autoscaler.path_to_values_file)]
  
  set {
    name  = "rbac.serviceAccount.name"
    value = "cluster-autoscaler"
  }

  set {
    name  = "autoDiscovery.clusterName"
    value = var.eks_name
  }

  # MUST be updated to match your region 
  set {
    name  = "awsRegion"
    value = var.cluster_autoscaler.region
  }

  depends_on = [helm_release.metrics_server]
}