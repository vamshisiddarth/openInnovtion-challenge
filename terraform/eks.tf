resource "tls_private_key" "nodes" {
  algorithm = "RSA"
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = local.cluster_name
  public_key = tls_private_key.nodes.public_key_openssh
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.26.1"
  cluster_name    = local.cluster_name
  cluster_version = local.cluster_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets
  enable_irsa     = true

  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  #Enable cluster access from Internet
  cluster_endpoint_public_access = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
  enable_cluster_creator_admin_permissions = true

  tags = {
    Environment = local.cluster_name
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  # Use managed node groups
  eks_managed_node_groups = {
    default = {
      name                          = "managed-node-group"
      instance_types                = ["t3.medium"]
      desired_size                  = 1
      min_size                      = 1
      max_size                      = 5
      capacity_type                 = "SPOT"
      additional_security_group_ids = [aws_security_group.nodes.id]
      key_name                      = module.key_pair.key_pair_name
      tags = {
        "k8s.io/cluster-autoscaler/enabled"               = "true"
        "k8s.io/cluster-autoscaler/${local.cluster_name}" = "owned"
      }
    }
  }

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  depends_on = [
    module.vpc
  ]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::094505923221:user/vamshisiddarth"
      username = "vamshisiddarth"
      groups   = ["system:masters"]
    }
  ]
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}