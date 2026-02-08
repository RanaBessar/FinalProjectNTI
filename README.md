# Final Project Terraform (EKS Infra)

This Terraform project provisions:
- VPC (Public/Private Subnets)
- NAT Gateway
- Route Tables
- IAM Roles for EKS Cluster & Nodegroup
- EKS Cluster
- Managed Node Group
- ECR Repository

## Platform Components

The project includes Helm charts for the complete platform pipeline:

### Core Platform Tools
1. **Nginx Ingress Controller** - Routes external traffic to services
   - Deployed in `ingress-nginx` namespace
   - LoadBalancer service for external access

2. **ArgoCD** - GitOps continuous deployment
   - Deployed in `argo` namespace
   - UI accessible at `argocd.local`
   - Syncs applications from Git repository

3. **Vault** - Secret management and encryption
   - Deployed in `vault` namespace
   - UI accessible at `vault.local`
   - Secure secret storage and rotation

4. **SonarQube** - Code quality and security analysis
   - Deployed in `sonarqube` namespace
   - UI accessible at `sonarqube.local`
   - Community edition with plugins

5. **Nexus Repository Manager** - Artifact and repository management
   - Deployed in `nexus` namespace
   - Accessible at `nexus.local`
   - Maven, Docker, and npm repository support

### Application
- **nti-app** - Sample application
  - Deployed in `nti-app` namespace
  - Managed by ArgoCD

## Region
us-east-1

## Run Locally

```bash
terraform init
terraform plan -var-file=nonprod.tfvars
terraform apply -var-file=nonprod.tfvars -auto-approve
```

## Destroy
```bash
terraform destroy -var-file=nonprod.tfvars -auto-approve
```

## Pipeline

The Azure Pipeline (`azure-pipline-infra.yaml`) automates:
1. **Terraform Stage** - Provisions AWS infrastructure
2. **Helm Deploy Stage** - Deploys all platform components and applications
3. **Terraform Destroy Stage** - Cleans up resources (conditional)

### Accessing Services
- **ArgoCD**: https://argocd.local
- **Vault**: https://vault.local
- **SonarQube**: https://sonarqube.local
- **Nexus**: https://nexus.local
- **Ingress Controller**: Manages all external access

### Helm Directory Structure
```
helm/
├── argocd-ingress.yaml
├── vault-ingress.yaml
├── sonarqube-ingress.yaml
├── nexus-ingress.yaml
├── nginx-ingress-controller/
│   ├── Chart.yaml
│   └── values.yaml
├── vault/
│   ├── Chart.yaml
│   └── values.yaml
├── sonarqube/
│   ├── Chart.yaml
│   └── values.yaml
└── nti-app/
    ├── Chart.yaml
    └── ...
```
