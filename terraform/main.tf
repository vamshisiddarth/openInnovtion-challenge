resource "kubernetes_namespace" "application" {
  metadata {
    name = "application"
  }

  depends_on = [
    module.eks,
    module.iam_assumable_role_admin
  ]
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }

  depends_on = [
    module.eks
  ]
}

resource "helm_release" "cluster_autoscaler" {
  name      = "cluster-autoscaler"
  namespace = "kube-system"

  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  version    = "9.43.2"

  values = [
    file("cluster_autoscaler/values.yaml")
  ]

  depends_on = [
    module.eks,
    module.iam_assumable_role_admin
  ]
}

resource "helm_release" "metrics_server" {
  name      = "metrics-server"
  namespace = "kube-system"

  repository = "https://kubernetes-sigs.github.io/metrics-server"
  chart      = "metrics-server"

  depends_on = [
    module.eks,
    module.iam_assumable_role_admin
  ]
}

resource "kubectl_manifest" "argocd" {
  yaml_body = file("${path.module}/argocd/argocd.yaml")
  override_namespace = kubernetes_namespace.argocd.metadata[0].name

  depends_on = [
    module.eks,
    kubernetes_namespace.argocd
  ]
}

resource "helm_release" "nginx" {
  name  = "nginx-ingress"

  repository = "https://helm.nginx.com/stable"
  chart = "nginx-ingress"

  namespace = kubernetes_namespace.application.metadata[0].name

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }

  depends_on = [
    module.eks,
    kubernetes_namespace.application
  ]
}