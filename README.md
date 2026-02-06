# Final Project Terraform (EKS Infra)

This Terraform project provisions:
- VPC (Public/Private Subnets)
- NAT Gateway
- Route Tables
- IAM Roles for EKS Cluster & Nodegroup
- EKS Cluster
- Managed Node Group
- ECR Repository

## Region
us-east-1

## Run Locally

terraform init
terraform plan -var-file=nonprod.tfvars
terraform apply -var-file=nonprod.tfvars -auto-approve

## Destroy
terraform destroy -var-file=nonprod.tfvars -auto-approve
