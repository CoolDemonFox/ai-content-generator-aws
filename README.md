# AI Content Generator - Cloud Native Application

![AWS](https://img.shields.io/badge/AWS-Lambda%20%2B%20DynamoDB-orange)
![Terraform](https://img.shields.io/badge/IaC-Terraform-purple)
![AI](https://img.shields.io/badge/AI-Google%20Gemini%202.0-blue)

AI-powered content generation platform built with AWS serverless architecture and Google Gemini API.

## 🚀 Features

- **Quick Templates**: Pre-built prompts for Instagram posts, emails, blog ideas, product descriptions
- **AI Content Editing**: Improve, expand, shorten, or regenerate content with one click
- **Generation History**: Track all generations with timestamps
- **Statistics Dashboard**: View total generations and usage metrics
- **Serverless Architecture**: 100% serverless, auto-scaling infrastructure

## 📊 Live Demo

**Live Demo**: http://ai-content-generator-cdf.s3-website.eu-central-1.amazonaws.com

## 🏗️ Architecture

Frontend (S3) → Lambda Function URL → AWS Lambda (Python 3.11)
├─→ Google Gemini 2.0 Flash API
└─→ DynamoDB (History Storage)
See [Architecture Documentation](docs/architecture.md) for detailed diagrams and flow.

## 🛠️ Tech Stack

### Cloud Services (AWS)
- **AWS Lambda**: Serverless compute (Python 3.11)
- **DynamoDB**: NoSQL database for generation history
- **Lambda Function URL**: HTTPS API endpoint
- **S3**: Static website hosting
- **IAM**: Role-based access control

### AI Integration
- **Google Gemini 2.0 Flash API**: Advanced text generation model

### Infrastructure as Code
- **Terraform**: Complete infrastructure provisioning and management

## 📦 Project Structure
ai-content-generator/
├── terraform/ # Infrastructure as Code
│ ├── provider.tf # AWS provider configuration
│ ├── variables.tf # Input variables
│ ├── main.tf # Main infrastructure resources
│ ├── outputs.tf # Output values
│ ├── iam.tf # IAM roles and policies
│ ├── lambda.tf # Lambda function configuration
│ ├── dynamodb.tf # DynamoDB table
│ ├── s3.tf # S3 bucket for frontend
│ └── lambda_function.zip # Lambda deployment package
├── docs/ # Documentation
│ ├── architecture.md # System architecture details
│ └── setup-guide.md # Deployment instructions
├── lambda_function.py # Lambda function code
├── index.html # Frontend application
├── requirements.txt # Python dependencies
└── README.md # This file

## 🚦 Quick Start

### Prerequisites
- AWS Account (free tier eligible)
- Terraform >= 1.0
- AWS CLI configured
- Google Gemini API key

### Deploy Infrastructure

1. Clone repository
git clone https://github.com/CoolDemonFox/ai-content-generator-aws.git
cd ai-content-generator-aws

2. Configure Gemini API key in lambda_function.py
Edit line with: api_key = 'YOUR_API_KEY'
3. Deploy with Terraform
cd terraform
terraform init
terraform apply

4. Deploy frontend to S3
cd ..
aws s3 cp index.html s3://ai-content-generator-cdf/ --content-type "text/html"

5. Open website
http://ai-content-generator-cdf.s3-website.eu-central-1.amazonaws.com

See [Setup Guide](docs/setup-guide.md) for detailed deployment instructions.

## 💰 Cost Analysis

**Monthly Cost**: $0 (within AWS and Gemini free tiers)

### Free Tier Limits
- **AWS Lambda**: 1M requests/month
- **DynamoDB**: 25GB storage + 200M requests/month
- **S3**: 5GB storage + 20,000 GET requests
- **Gemini API**: 250 requests/day (10 RPM)

**Estimated cost beyond free tier**: ~$0.50-$2.00/month for moderate usage

## 📚 Documentation

- [Architecture Documentation](docs/architecture.md) - Detailed system design and data flows
- [Setup & Deployment Guide](docs/setup-guide.md) - Step-by-step deployment instructions

## 🔒 Security

### Implemented
- HTTPS-only communication via AWS
- IAM roles with least-privilege principle
- CORS configuration on API endpoints
- Input validation in Lambda function
- Public read-only access for S3 static assets

### Production Recommendations
- Move API keys to AWS Secrets Manager
- Add user authentication (AWS Cognito)
- Implement rate limiting per IP
- Enable CloudWatch alarms for errors
- Add AWS WAF for DDoS protection

## 📈 Scalability

### Current Design
- **Lambda**: Auto-scales to 1000 concurrent executions
- **DynamoDB**: On-demand scaling for any workload
- **S3**: Unlimited storage and bandwidth

### Bottlenecks
- Gemini API rate limits (10 RPM free tier)
- Solution: Implement request queuing with SQS or upgrade to paid tier

## 📊 Monitoring

### Metrics Tracked
- Lambda invocations and errors
- DynamoDB read/write capacity
- API response times
- Generation success rate

### Tools
- AWS CloudWatch Logs
- CloudWatch Metrics
- Optional: X-Ray for distributed tracing

## 🎯 Future Enhancements

- [ ] User authentication and personal accounts
- [ ] Content export (PDF, DOCX, Markdown)
- [ ] Real-time streaming responses
- [ ] Voice input support (Web Speech API)
- [ ] Multi-language content generation
- [ ] Content templates marketplace
- [ ] Collaborative features

## 👨‍💻 Author

**CoolDemonFox** - IITU Student
- Final Project: Cloud-Native AI Application Deployment
- Course: Cloud Infrastructure and DevOps
- December 2025

## 📄 License

This project is developed for educational purposes as part of university coursework.

## 🙏 Acknowledgments

- Google Gemini API for AI capabilities
- AWS Free Tier for cloud infrastructure
- Terraform for Infrastructure as Code
- IITU for project guidance

---

**Project Repository**: https://github.com/CoolDemonFox/ai-content-generator-aws
