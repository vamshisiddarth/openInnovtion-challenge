locals {
  cluster_name                  = "challenge"
  cluster_version               = "1.30"
  k8s_service_account_namespace = "kube-system"
  k8s_service_account_name      = "cluster-autoscaler-aws-cluster-autoscaler-chart"

  iam_role_policy_prefix = ""
  cni_policy = ""
}