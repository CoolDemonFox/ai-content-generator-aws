# Architecture Documentation

## System Overview

The **AI Content Generator** is a serverless, cloud-native application that combines:
- **Frontend:** Static HTML/JS hosted on S3
- **API:** API Gateway routing requests
- **Backend:** AWS Lambda for business logic
- **Storage:** DynamoDB for history & audit
- **AI:** Google Gemini API for content generation

## Data Flow

### 1. User Interaction → Frontend (S3)
```
1. User enters prompt in browser
2. Frontend JavaScript validates input
3. Browser makes HTTPS POST request to API Gateway
```

### 2. API Gateway → Lambda
```
1. API Gateway receives request at /generate
2. Validates CORS headers
3. Routes to Lambda function
4. Passes prompt as JSON payload
```

### 3. Lambda Processing
```
1. Lambda receives event from API Gateway
2. Extracts user prompt
3. Calls Google Gemini API
4. Receives generated text
5. Saves prompt + response to DynamoDB
6. Returns response to API Gateway
```

### 4. Response → Frontend
```
1. API Gateway formats Lambda response
2. Browser receives JSON with generated content
3. Frontend displays content in UI
4. User can copy or generate again
```

### 5. History Retrieval
```
GET /history
1. Frontend requests generation history
2. Lambda queries DynamoDB
3. Returns last 20 generations
4. Frontend displays timeline
```

## Service Dependencies

| Service | Role | Free Tier |
|---------|------|-----------|
| **S3** | Frontend Hosting | 5 GB/month |
| **Lambda** | Business Logic | 1M requests/month |
| **API Gateway** | REST API | 1M calls/month |
| **DynamoDB** | NoSQL Storage | 25 GB storage |
| **Gemini API** | AI Model | 60 req/min free |

## Security Architecture

### IAM Permissions (Principle of Least Privilege)

**Lambda Execution Role:**
- ✅ `dynamodb:PutItem` - Write to history
- ✅ `dynamodb:Query` - Read history
- ✅ `dynamodb:Scan` - List history
- ✅ `logs:CreateLogGroup` - CloudWatch logging
- ❌ No S3 access
- ❌ No EC2 access

### CORS Configuration

API Gateway allows:
- ✅ GET, POST, OPTIONS from any origin
- ✅ Content-Type header
- ✅ Credentials disabled (public API)

### Gemini API Security
- API key stored in Lambda environment variables (encrypted at rest)
- API key not exposed in frontend code
- API calls signed by Lambda

## Scalability

### Horizontal Scaling

| Component | Scaling | Limit |
|-----------|---------|-------|
| **Lambda** | Automatic | 1000 concurrent |
| **API Gateway** | Automatic | 10k req/sec |
| **DynamoDB** | On-demand | 40k WCU, 40k RCU |
| **S3** | Auto | Unlimited |

### Performance Optimization

1. **Lambda Memory:** 256 MB → Fast enough for Gemini calls
2. **DynamoDB:** On-demand billing → Auto-scale
3. **S3:** Website hosting → Global CDN ready
4. **TTL:** History expires after 30 days → Cost control

## Cost Breakdown

### Free Tier Usage
```
Lambda:       500,000 requests × 0 = $0
S3:           100 MB storage = $0
DynamoDB:     1000 items × 0 = $0
API Gateway:  500,000 calls × 0 = $0
Gemini API:   1000 requests/month × 0 = $0
─────────────────────────────────────
TOTAL: ~$0/month (within free tier)
```

### Paid Tier (After Free Tier)
```
Lambda:       $0.20 per 1M requests
S3:           $0.023 per 1 GB
DynamoDB:     $1.25 per 1M writes
API Gateway:  $3.50 per 1M calls
Gemini API:   $2.50 per 1M tokens
```

## Disaster Recovery

### Data Backup
- DynamoDB: Manual backup (via AWS console)
- TTL: Auto-delete after 30 days
- No built-in replication (upgrade for production)

### Failover Strategy
- API Gateway: Multi-region capable
- Lambda: Automatic retry (3x)
- S3: Static content (no downtime)

## Monitoring & Observability

### CloudWatch Metrics
```bash
# Lambda Invocations
aws cloudwatch get-metric-statistics \
  --namespace AWS/Lambda \
  --metric-name Invocations \
  --start-time 2024-01-01T00:00:00Z \
  --end-time 2024-01-02T00:00:00Z \
  --period 3600 \
  --statistics Sum
```

### Logs
```bash
# Real-time log tail
aws logs tail /aws/lambda/ai-content-generator-dev --follow
```

### Alerts (Optional Setup)
```bash
# Create alarm for Lambda errors
aws cloudwatch put-metric-alarm \
  --alarm-name lambda-errors \
  --metric-name Errors \
  --namespace AWS/Lambda \
  --statistic Sum \
  --period 300 \
  --threshold 10
```

## Future Enhancements

### Phase 2: Authentication
- Add user accounts (Cognito)
- API key generation per user
- Usage quotas per user

### Phase 3: Multi-Model Support
- Support Claude, GPT-4, Cohere
- Model selection in UI
- A/B testing framework

### Phase 4: Advanced Features
- Prompt templates
- Batch processing
- Email delivery of results
- Webhooks for automation

### Phase 5: Production Hardening
- Auto-scaling policies
- Multi-region deployment
- DynamoDB global tables
- VPC isolation
- KMS encryption

## Compliance

✅ **GDPR Ready:** Can implement data deletion
✅ **SOC 2 Ready:** Audit logging enabled
✅ **Cost Optimized:** Free tier + auto-scaling
✅ **Secure:** IAM least privilege + CORS
