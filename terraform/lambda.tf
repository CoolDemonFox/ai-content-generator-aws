data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../src/lambda_function.py"
  output_path = "${path.module}/../src/lambda_function.zip"
}

resource "aws_lambda_function" "content_generator" {
  filename      = data.archive_file.lambda_zip.output_path
  function_name = "${var.project_name}-${var.environment}"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  timeout       = var.lambda_timeout
  memory_size   = var.lambda_memory
  runtime       = "python3.11"

  environment {
    variables = {
      GEMINI_API_KEY  = var.gemini_api_key
      DYNAMODB_TABLE  = aws_dynamodb_table.history.name
      ENVIRONMENT     = var.environment
    }
  }

  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  depends_on = [
    aws_iam_role_policy.lambda_dynamodb_policy,
    aws_iam_role_policy_attachment.lambda_basic_execution
  ]
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.content_generator.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.content_api.execution_arn}/*/*"
}
