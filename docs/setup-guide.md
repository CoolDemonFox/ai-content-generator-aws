# AI Content Generator - Setup Guide

## Prerequisites

1. **AWS Account** - Free tier eligible
2. **Terraform** - v1.0+
3. **Google Gemini API Key** - Get it at https://ai.google.dev
4. **AWS CLI** - Configured with credentials

## Step-by-Step Deployment

### 1. Get Your Google Gemini API Key

1. Visit [Google AI Studio](https://ai.google.dev)
2. Click "Get API Key"
3. Create a new API key in Google Cloud Console
4. Copy the key (keep it safe!)

### 2. Clone/Setup Project Structure

```bash
mkdir ai-content-generator
cd ai-content-generator

# Create directories
mkdir -p terraform src frontend docs

# Copy all the files to their locations:
# - terraform/*.tf files → terraform/
# - src/lambda_function.py → src/
# - src/requirements.txt → src/
# - frontend/index.html → frontend/
```

### 3. Configure Terraform Variables

Edit `terraform/terraform.tfvars`:

```hcl
aws_region       = "us-east-1"  # Change if needed
project_name     = "ai-content-generator"
environment      = "dev"
gemini_api_key   = "YOUR_ACTUAL_GEMINI_KEY_HERE"  # Paste your key
```

### 4. Deploy Infrastructure

```bash
cd terraform

# Initialize Terraform
terraform init

# Plan the deployment
terraform plan

# Apply infrastructure
terraform apply

# Save outputs
terraform output > ../deployment-info.txt
```

**Output will show:**
- S3 Website Endpoint (your frontend URL)
- API Gateway URL (your backend API)
- Lambda Function Name
- DynamoDB Table Name

### 5. Configure Frontend

After deployment, you need to tell the frontend where the API is.

**Option A: Browser Console (Quick)**
```javascript
// Open browser console (F12)
// Paste this and replace with your API URL:
setApiUrl('https://YOUR-API-ID.execute-api.us-east-1.amazonaws.com/prod')

// Then refresh the page
```

**Option B: Edit HTML (Permanent)**
Edit `frontend/index.html` and change:
```javascript
const API_BASE = 'https://YOUR-API-ID.execute-api.us-east-1.amazonaws.com/prod';
```

### 6. Test the Application

1. Visit the S3 website endpoint from terraform output
2. Type a prompt: "Write a haiku about technology"
3. Click "Generate Content"
4. Check "Generation History" tab

## Troubleshooting

### Lambda Timeout Error
- Increase `lambda_timeout` in `terraform.tfvars` (default: 30s)
- Gemini API calls can take 15-25 seconds

### CORS Issues
- API Gateway CORS is configured automatically
- Frontend must be served over HTTP/HTTPS (S3 handles this)

### Gemini API Rate Limit
- Free tier: 60 requests per minute
- Wait a moment between requests or upgrade plan

### DynamoDB Errors
- Check IAM permissions in `iam.tf`
- Verify table name matches Lambda environment variables

## Cost Tracking

**Free Tier Limits (monthly):**
- Lambda: 1 million requests
- S3: 5 GB storage + standard requests
- DynamoDB: 25 GB storage, unlimited WCU/RCU (pay-per-request)
- API Gateway: 1 million requests
- Gemini API: 60 requests/minute (free)

**Estimated Monthly Cost:** ~$0 (within free tier)

Use AWS Cost Calculator to monitor:
```bash
# Check Lambda invocations
aws lambda get-function \
  --function-name ai-content-generator-dev \
  --query 'Configuration'

# Check DynamoDB usage
aws dynamodb describe-table \
  --table-name ai-content-generator-content-history-dev \
  --query 'Table.TableStatus'
```

## Architecture Diagram

```
User Browser
    ↓
S3 Hosted Frontend (index.html)
    ↓ (HTTPS API calls)
API Gateway
    ↓ (routes /generate, /history)
Lambda Function (Python)
    ├→ Google Gemini API (AI)
    └→ DynamoDB (History Storage)
```

## Monitoring

### CloudWatch Logs
```bash
# View Lambda logs
aws logs tail /aws/lambda/ai-content-generator-dev --follow
```

### Performance Metrics
- **Cold Start:** ~3-5 seconds (first invocation)
- **Warm Start:** ~100-500ms (subsequent invocations)
- **Gemini API Response:** ~15-25 seconds

## Clean Up (Delete Resources)

```bash
cd terraform
terraform destroy
```

This will delete:
- Lambda function
- API Gateway
- DynamoDB table
- S3 bucket
- IAM roles

## Next Steps

**Enhance the Project:**
1. Add authentication (API keys/JWT)
2. Implement rate limiting per user
3. Add different content templates
4. Create custom Gemini prompt system
5. Add email notifications
6. Deploy CI/CD with GitHub Actions

## Support

**Resources:**
- [AWS Lambda Documentation](https://docs.aws.amazon.com/lambda/)
- [Google Gemini API Docs](https://ai.google.dev/docs)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
