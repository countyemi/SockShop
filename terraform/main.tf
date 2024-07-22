provider "aws" {
  region = var.region
}

 


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "SockShop-vpc"

  cidr = "10.0.0.0/16"
  azs  = var.AZ

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster-public/${var.cluster_name}" = "shared"
    
  }

  private_subnet_tags = {
    "kubernetes.io/cluster-private/${var.cluster_name}" = "shared"
    
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.30"

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type                    = "AL2_x86_64"
   
  }

  eks_managed_node_groups = {
    one = {
      name = "node-grp-1"

      instance_types = ["t2.medium"]

      min_size     = 1
      max_size     = 2
      desired_size = 2
    }

    two = {
      name = "node-grp-2"

      instance_types = ["t2.medium"]

      min_size     = 1
      max_size     = 2
      desired_size = 2
    }
  }
enable_cluster_creator_admin_permissions = true
}
