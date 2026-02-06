locals {
  common_tags = merge(
    {
      Project     = "FinalProject"
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}

module "networking" {
  source = "./modules/networking"

  name_prefix          = var.name_prefix
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  tags = local.common_tags
}

module "iam" {
  source = "./modules/iam"

  name_prefix = var.name_prefix
  environment = var.environment

  tags = local.common_tags
}

module "eks" {
  source = "./modules/eks"

  name_prefix = var.name_prefix
  environment = var.environment

  cluster_version = var.cluster_version

  vpc_id             = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids

  cluster_role_arn = module.iam.eks_cluster_role_arn
  node_role_arn = module.iam.eks_node_role_arn

  node_instance_types = var.node_instance_types
  desired_size        = var.desired_size
  min_size            = var.min_size
  max_size            = var.max_size

  tags = local.common_tags
}
