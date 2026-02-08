# Azure DevOps Pipeline Setup Guide

## Prerequisites

Before running any pipeline, you need to configure Azure DevOps with the necessary variables.

## Setting Up Pipeline Variables

### Step 1: Go to Azure DevOps Pipeline Settings

1. Navigate to your Azure DevOps project
2. Go to **Pipelines**
3. Select the pipeline you want to configure
4. Click **Edit**
5. Click the **⋮ (three dots)** menu → **Triggers**
6. Scroll down and click **Variables**

### Step 2: Add Required Variables

Add these variables to **each pipeline** (or set them at the project level):

#### **Required AWS Credentials**
```
AWS_ACCESS_KEY_ID: <your-aws-access-key>
AWS_SECRET_ACCESS_KEY: <your-aws-secret-key>
AWS_DEFAULT_REGION: us-east-1
```

Mark `AWS_SECRET_ACCESS_KEY` as **secret** (click the lock icon)

---

## Variables Guide

### For All Pipelines

| Variable | Value | Required | Secret |
|----------|-------|----------|--------|
| `AWS_ACCESS_KEY_ID` | Your AWS Access Key ID | ✅ Yes | ❌ No |
| `AWS_SECRET_ACCESS_KEY` | Your AWS Secret Access Key | ✅ Yes | ✅ **Yes** |
| `AWS_DEFAULT_REGION` | `us-east-1` or your region | ✅ Yes | ❌ No |

### Pipeline-Specific Variables

#### Infrastructure Pipeline (`azure-infra-pipeline.yaml`)
- Uses: VPC CIDR, Subnet CIDRs, Node configurations
- Defaults available in `nonprod.tfvars`

#### Platform Pipeline (`azure-platform-pipeline.yaml`)
- Uses AWS credentials to access EKS cluster
- No additional variables needed

#### CI Pipeline (`azure-ci-pipeline.yaml`)
- Uses AWS credentials for ECR access
- Docker builds automatically with BuildKit

#### CD Pipeline (`azure-cd-pipeline.yaml`)
- Uses AWS credentials to access EKS
- ArgoCD syncs from GitHub repository

---

## Troubleshooting

### Error: "The security token included in the request is invalid"

**Cause:** AWS credentials are not set or are incorrect

**Solution:**
1. Verify AWS Access Key ID is correct
2. Verify AWS Secret Access Key is correct (it's marked as secret)
3. Ensure the IAM user has permissions:
   - `eks:ListClusters`
   - `eks:DescribeCluster`
   - `ecr:GetAuthorizationToken`
   - `ecr:DescribeImages`
   - `s3:*` (for Terraform state)
   - `dynamodb:*` (for Terraform lock)

### Error: "UnrecognizedClientException"

**Cause:** Invalid AWS credentials or IAM user doesn't exist

**Solution:**
1. Generate new IAM credentials in AWS Console
2. Update variables in Azure DevOps
3. Ensure IAM user has programmatic access enabled

### Error: "You must be logged in to the server (Unauthorized)"

**Cause:** EKS cluster doesn't exist or credentials don't have EKS access

**Solution:**
1. Run Infrastructure Pipeline first to create the cluster
2. Wait for cluster to be fully provisioned (~10-15 minutes)
3. Verify IAM user has EKS permissions

---

## Setting Up IAM User

If you don't have AWS credentials yet, create an IAM user:

1. Go to AWS Console → **IAM**
2. Click **Users** → **Create user**
3. Set a username (e.g., `azure-devops-pipeline`)
4. Click **Attach policies directly**
5. Select these policies:
   - `AmazonEKSFullAccess`
   - `AmazonEC2FullAccess`
   - `AmazonVPCFullAccess`
   - `AmazonS3FullAccess`
   - `AmazonDynamoDBFullAccess`
   - `AmazonElasticContainerRegistryPublicFullAccess`
   - `IAMFullAccess`
6. Click **Create user**
7. Go to **Security credentials**
8. Click **Create access key**
9. Choose **Application running outside AWS**
10. Copy the **Access Key ID** and **Secret Access Key**
11. Paste into Azure DevOps variables

---

## Execution Order

```
1️⃣  Infrastructure Pipeline
    (Creates VPC, EKS, ECR, IAM)
    ↓
2️⃣  Platform Pipeline
    (Deploys Nginx, ArgoCD, Vault, SonarQube, Nexus)
    ↓
3️⃣  CI Pipeline (on code changes)
    (Builds Docker image, scans with Trivy, pushes to ECR)
    ↓
4️⃣  CD Pipeline (on deployment config changes)
    (Deploys app via Helm, verifies with ArgoCD)
```

---

## Best Practices

✅ **DO:**
- Mark `AWS_SECRET_ACCESS_KEY` as secret
- Use a dedicated IAM user for pipelines
- Rotate credentials periodically
- Store credentials in Azure DevOps secret variables
- Use least-privilege IAM policies

❌ **DON'T:**
- Commit credentials to Git
- Share credentials in Slack/Teams
- Use root AWS account for pipelines
- Commit `.kube/config` files

---

## Getting Help

Each pipeline step validates prerequisites and provides helpful error messages.

If a pipeline fails:
1. Read the error message carefully
2. Check the variables are set correctly
3. Verify AWS credentials have necessary permissions
4. Check that EKS cluster has finished bootstrapping
