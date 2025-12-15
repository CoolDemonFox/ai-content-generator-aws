variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "ai-content-generator-dev"
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  type        = string
  default     = "content_history"
}

variable "python_runtime" {
  description = "Python runtime version"
  type        = string
  default     = "python3.11"
}
