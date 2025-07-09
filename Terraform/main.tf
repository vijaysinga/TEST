terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.40.0"  # ✅ ensures latest features are supported
    }
  }
}


module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.8.4" # latest stable at the time

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  # VPC and subnets
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  #manage_aws_auth_configmap       = true  # ✅ Must be enabled to manage access
  enable_cluster_creator_admin_permissions = true  # ✅ Gives current user admin access


  enable_irsa = true

  cluster_endpoint_public_access = true

  # Node group
  eks_managed_node_groups = {
    default = {
      desired_size = 2
      max_size     = 3
      min_size     = 1

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
      iam_role_arn = "<IAM_ARN>"
    }

  }
  # ✅ Add IAM access to the EKS cluster
   access_entries = {
  admin = {
    principal_arn = "<IAM_ARN>"

    policy_associations = {
      admin-access = {
        policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
        access_scope = {
          type = "cluster"
        }
      }
    }
  }
}

}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name = "eks-vpc"
  cidr = "10.0.0.0/16"

  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

data "aws_availability_zones" "available" {}
