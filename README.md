# Final Project Terraform (EKS Infra)

This project provides a complete infrastructure and platform pipeline for deploying applications on AWS EKS with integrated DevOps tools.

## Project Overview

This project provisions:
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

## Azure Pipelines Architecture

The project uses 4 separate Azure Pipelines for different stages:

### 1. **Infrastructure Pipeline** (`azure-infra-pipeline.yaml`)
Provisions AWS infrastructure and EKS cluster.

**Stages:**
- **Terraform Validate** - Validates infrastructure code
  - Format check
  - Terraform validation
  - Plan generation
  
- **Terraform Apply** - Deploys infrastructure
  - Setup S3 backend
  - Setup DynamoDB lock table
  - Apply Terraform
  
- **Terraform Destroy** (Optional) - Cleanup infrastructure

**Triggers:** Changes to `terraform/` folder

**Output:**
- VPC with public/private subnets
- NAT Gateway and Route Tables
- EKS Cluster and Managed Node Groups
- ECR Repository
- IAM Roles and Policies

---

### 2. **Platform Pipeline** (`azure-platform-pipeline.yaml`)
Deploys platform tools and infrastructure components.

**Stages:**
- **Platform Deploy** - Installs all platform components
  1. Nginx Ingress Controller
  2. ArgoCD
  3. Vault
  4. SonarQube
  5. Nexus Repository Manager
  
- **Platform Cleanup** (Optional) - Removes all platform components

**Triggers:** Changes to `helm/vault/`, `helm/sonarqube/`, `helm/nginx-ingress-controller/`, ingress files

**Dependencies:** Requires working EKS cluster from Infrastructure Pipeline

**Services:**
- ArgoCD UI: `https://argocd.local`
- Vault UI: `https://vault.local`
- SonarQube: `https://sonarqube.local`
- Nexus: `https://nexus.local`

---

### 3. **CI Pipeline** (`azure-ci-pipeline.yaml`)
Builds and scans Docker images.

**Stages:**
- **Build** - Build Docker image
  - Get ECR repository details
  - Build image with BuildKit
  - Show image information
  
- **Security Scan** - Scan with Trivy
  - Install Trivy scanner
  - Scan for vulnerabilities
  - Generate security reports
  
- **Push** - Push to ECR
  - Login to ECR
  - Push image with build tag and latest tag
  - Verify image in ECR

**Triggers:** Changes to `app/`, `Dockerfile`, `.dockerignore`

**Pull Request:** Runs on PRs to validate code

**Outputs:**
- Image in ECR: `{AWS_ACCOUNT}.dkr.ecr.us-east-1.amazonaws.com/nti-app:{BUILD_ID}`
- Trivy security reports as artifacts

---

### 4. **CD Pipeline** (`azure-cd-pipeline.yaml`)
Deploys application using Helm and ArgoCD.

**Stages:**
- **Validate** - Validates deployment configuration
  - Helm lint
  - YAML validation
  - Helm dry-run
  
- **Deploy Application** - Deploys nti-app
  - Configure kubeconfig
  - Helm upgrade/install
  - Wait for deployment
  
- **ArgoCD Sync** - Verifies ArgoCD synchronization
  - Check ArgoCD status
  - Confirm applications are synced
  
- **Verify** - Verifies deployment
  - Check pod status
  - Verify services
  - Show deployment summary

**Triggers:** Changes to `gitops/`, `helm/nti-app/`

**Dependencies:** Requires working Kubernetes cluster and platform components

---

## Pipeline Execution Order

```
Infrastructure Pipeline
    ↓
Platform Pipeline
    ↓
CI Pipeline (on code changes)
    ↓
CD Pipeline (on deployment config changes)
```

## Run Locally

```bash
# Terraform
terraform init
terraform plan -var-file=nonprod.tfvars
terraform apply -var-file=nonprod.tfvars -auto-approve

# Helm
helm repo add stable https://charts.helm.sh/stable
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo add sonarqube https://SonarSource.github.io/helm-chart-sonarqube
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add sonatype https://sonatype.github.io/helm3-charts
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
```

## Destroy

```bash
# Cleanup platform (optional)
helm uninstall ingress-nginx -n ingress-nginx
helm uninstall argocd -n argo
helm uninstall vault -n vault
helm uninstall sonarqube -n sonarqube
helm uninstall nexus -n nexus

# Destroy infrastructure
terraform destroy -var-file=nonprod.tfvars -auto-approve
```

## Helm Directory Structure
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
    ├── values.yaml
    └── ...
```

## GitOps Directory Structure
```
gitops/
└── nonprod/
    └── nti-app/
        ├── application.yaml
        ├── Chart.yaml
        ├── values-nonprod.yaml
        └── templates/
```

## Environment Variables for Pipelines

Set the following in Azure DevOps Pipeline Variables:

- `AWS_ACCESS_KEY_ID` - AWS access key ID
- `AWS_SECRET_ACCESS_KEY` - AWS secret access key
- `AWS_DEFAULT_REGION` - AWS region (default: us-east-1)

## Accessing Services

After successful deployment:

- **ArgoCD**: https://argocd.local
- **Vault**: https://vault.local
- **SonarQube**: https://sonarqube.local
- **Nexus**: https://nexus.local
- **Application**: Managed by ArgoCD

## Architecture Diagram

```
┌─────────────────────────────────────────────┐
│     Infrastructure Pipeline                  │
│     (VPC, EKS, IAM, ECR)                    │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│     Platform Pipeline                        │
│ (Nginx, ArgoCD, Vault, SonarQube, Nexus)    │
└─────────────────────────────────────────────┘
                    ↓
        ┌───────────┴───────────┐
        ↓                       ↓
    CI Pipeline            CD Pipeline
  (Build & Scan)    (Deploy & Verify)
```
