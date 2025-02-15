module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
    aws-ebs-csi-driver     = {}
    amazon-cloudwatch-observability = {}
  }

  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnet_ids
  control_plane_subnet_ids = var.control_plane_subnet_ids

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t4g.medium", "m7i.large"]
  }

  eks_managed_node_groups = {
    kkamji_eks_nodes = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type = "AL2023_ARM_64_STANDARD"
      # ami_type = "AL2023_x86_64_STANDARD"
      # 해당 부분에 instance_types를 명시하지 않을 경우 위에 있는 instance_type 중 생성됨
      instance_types = var.instance_types
      min_size       = var.min_size
      max_size       = var.max_size
      desired_size   = var.desired_size
      key_name       = var.key_name
      user_data      = var.user_data
    }
  }
  create_cluster_primary_security_group_tags = false
  # Cluster access entry
  # 클러스터를 생성한 사용자를 관리자로 설정할지 여부
  enable_cluster_creator_admin_permissions = true

  tags = {
    "karpenter.sh/discovery" = "kkamji"
  }
}

