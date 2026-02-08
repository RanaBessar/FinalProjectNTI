# Azure Pipeline Troubleshooting Guide

## Error: "The security token included in the request is invalid"

This error means your AWS credentials are either **missing**, **incorrect**, or **expired**.

---

## Debugging Checklist

### ✅ Step 1: Verify Variables Are Set in Azure DevOps

1. Go to **Pipelines** → Your pipeline → **Edit**
2. Click **⋮ (menu)** → **Variables**
3. Check these **4 variables** are visible:
   - `AWS_ACCESS_KEY_ID` (value should be hidden if secret)
   - `AWS_SECRET_ACCESS_KEY` (value should be **hidden with lock icon**)
   - `AWS_SESSION_TOKEN` (optional)
   - `AWS_DEFAULT_REGION` (should be `us-east-1`)

**If any are missing → Add them and save**

---

### ✅ Step 2: Verify Credentials Locally on Your Machine

```bash
# Test with your credentials
export AWS_ACCESS_KEY_ID=your-access-key
export AWS_SECRET_ACCESS_KEY=your-secret-key
export AWS_DEFAULT_REGION=us-east-1

# This should work without errors:
aws sts get-caller-identity

# You should see output like:
# {
#     "UserId": "AIDAJ45Q7YFFAREXAMPLE",
#     "Account": "123456789012",
#     "Arn": "arn:aws:iam::123456789012:user/your-user"
# }
```

**If this fails → Credentials are wrong or expired**

---

### ✅ Step 3: Verify Credentials Have Correct Permissions

Your IAM user needs these policies:

```
✅ AmazonEKSFullAccess
✅ AmazonEC2FullAccess  
✅ AmazonVPCFullAccess
✅ AmazonS3FullAccess
✅ AmazonDynamoDBFullAccess
✅ AmazonElasticContainerRegistryPublicFullAccess
✅ IAMFullAccess
```

**To check:**
1. Go to AWS IAM Console
2. Find your user
3. Check "Permissions" tab
4. Verify all policies are attached

---

### ✅ Step 4: Verify No Extra Spaces in Variables

Common mistake: Extra spaces copied with the credential

```
❌ WRONG: " AKIAIOSFODNN7EXAMPLE " (has spaces)
✅ RIGHT: "AKIAIOSFODNN7EXAMPLE" (no spaces)
```

**To fix:**
1. Go to Azure DevOps variable
2. Delete the value completely
3. Copy-paste the credential again (carefully, no extra spaces)
4. Save

---

### ✅ Step 5: Regenerate Credentials if Expired

AWS Access Keys that are 90+ days old may expire.

**To regenerate:**
1. Go to AWS IAM Console → **Users** → Your user
2. go to **Security credentials** tab
3. Find your access key → Click **Delete**
4. Click **Create Access Key** (at bottom)
5. Choose **Application running outside AWS**
6. Copy the new Access Key ID and Secret Key
7. Update both in Azure DevOps variables
8. Delete the old credentials in AWS

---

### ✅ Step 6: Verify Infrastructure Pipeline Ran First

The platform pipeline **requires an EKS cluster** that was created by the Infrastructure Pipeline.

**To check:**
```bash
# Run this locally:
export AWS_ACCESS_KEY_ID=your-key
export AWS_SECRET_ACCESS_KEY=your-secret
export AWS_DEFAULT_REGION=us-east-1

aws eks list-clusters
# Should return at least one cluster
```

**If no clusters → Run Infrastructure Pipeline first**

---

## Common Errors

### Error: "UnrecognizedClientException"
- **Cause:** Access Key ID is invalid or wrong
- **Fix:** Regenerate credentials in AWS IAM

### Error: "InvalidClientTokenId"  
- **Cause:** Secret Key is invalid or wrong
- **Fix:** Regenerate credentials in AWS IAM

### Error: "User is not authorized"
- **Cause:** Credentials don't have IAM permissions
- **Fix:** Attach the policies listed in Step 3

### Error: "No EKS clusters found"
- **Cause:** Infrastructure Pipeline hasn't run yet
- **Fix:** Run Infrastructure Pipeline → wait 10-15 min → run Platform Pipeline

---

## Quick Fix Checklist

```
Run through these steps in order:

□ 1. Verify 4 variables are in Azure DevOps
□ 2. Test credentials locally with aws sts get-caller-identity
□ 3. Check IAM user has all 7 required policies
□ 4. Remove extra spaces from variable values
□ 5. Regenerate credentials if older than 90 days
□ 6. Run Infrastructure Pipeline first (if not done)
□ 7. Re-run Platform Pipeline
```

---

## Still Not Working?

Add this curl command to test before running pipeline:

```bash
# Test endpoint connectivity
curl -v https://sts.amazonaws.com/

# Should get a response (not timeout)
# If it times out → Network/firewall issue
```

---

## Need More Help?

Check the detailed setup guide:
- [PIPELINES_SETUP.md](PIPELINES_SETUP.md) - Full setup instructions
- [README.md](README.md) - Architecture overview
