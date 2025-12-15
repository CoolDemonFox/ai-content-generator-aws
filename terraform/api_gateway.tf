resource "aws_api_gateway_rest_api" "content_api" {
  name        = "${var.project_name}-api-${var.environment}"
  description = "API for AI Content Generator"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# GET /history endpoint
resource "aws_api_gateway_resource" "history" {
  rest_api_id = aws_api_gateway_rest_api.content_api.id
  parent_id   = aws_api_gateway_rest_api.content_api.root_resource_id
  path_part   = "history"
}

resource "aws_api_gateway_method" "history_get" {
  rest_api_id      = aws_api_gateway_rest_api.content_api.id
  resource_id      = aws_api_gateway_resource.history.id
  http_method      = "GET"
  authorization    = "NONE"
}

resource "aws_api_gateway_integration" "history_lambda" {
  rest_api_id      = aws_api_gateway_rest_api.content_api.id
  resource_id      = aws_api_gateway_resource.history.id
  http_method      = aws_api_gateway_method.history_get.http_method
  type             = "AWS_PROXY"
  integration_http_method = "POST"
  uri              = aws_lambda_function.content_generator.invoke_arn
}

resource "aws_api_gateway_method_response" "history_get_200" {
  rest_api_id = aws_api_gateway_rest_api.content_api.id
  resource_id = aws_api_gateway_resource.history.id
  http_method = aws_api_gateway_method.history_get.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "history_get_200" {
  rest_api_id = aws_api_gateway_rest_api.content_api.id
  resource_id = aws_api_gateway_resource.history.id
  http_method = aws_api_gateway_method.history_get.http_method
  status_code = aws_api_gateway_method_response.history_get_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,OPTIONS'"
  }

  depends_on = [aws_api_gateway_integration.history_lambda]
}

# OPTIONS for /history
resource "aws_api_gateway_method" "history_options" {
  rest_api_id   = aws_api_gateway_rest_api.content_api.id
  resource_id   = aws_api_gateway_resource.history.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "history_options" {
  rest_api_id = aws_api_gateway_rest_api.content_api.id
  resource_id = aws_api_gateway_resource.history.id
  http_method = aws_api_gateway_method.history_options.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = jsonencode({ statusCode = 200 })
  }
}

resource "aws_api_gateway_method_response" "history_options" {
  rest_api_id = aws_api_gateway_rest_api.content_api.id
  resource_id = aws_api_gateway_resource.history.id
  http_method = aws_api_gateway_method.history_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "history_options" {
  rest_api_id = aws_api_gateway_rest_api.content_api.id
  resource_id = aws_api_gateway_resource.history.id
  http_method = aws_api_gateway_method.history_options.http_method
  status_code = aws_api_gateway_method_response.history_options.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [aws_api_gateway_integration.history_options]
}

# POST /generate endpoint
resource "aws_api_gateway_resource" "generate" {
  rest_api_id = aws_api_gateway_rest_api.content_api.id
  parent_id   = aws_api_gateway_rest_api.content_api.root_resource_id
  path_part   = "generate"
}

resource "aws_api_gateway_method" "generate_post" {
  rest_api_id      = aws_api_gateway_rest_api.content_api.id
  resource_id      = aws_api_gateway_resource.generate.id
  http_method      = "POST"
  authorization    = "NONE"
}

resource "aws_api_gateway_integration" "generate_lambda" {
  rest_api_id      = aws_api_gateway_rest_api.content_api.id
  resource_id      = aws_api_gateway_resource.generate.id
  http_method      = aws_api_gateway_method.generate_post.http_method
  type             = "AWS_PROXY"
  integration_http_method = "POST"
  uri              = aws_lambda_function.content_generator.invoke_arn
}

# Method response for POST /generate (CORS)
resource "aws_api_gateway_method_response" "generate_post_200" {
  rest_api_id = aws_api_gateway_rest_api.content_api.id
  resource_id = aws_api_gateway_resource.generate.id
  http_method = aws_api_gateway_method.generate_post.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
}

resource "aws_api_gateway_integration_response" "generate_post_200" {
  rest_api_id = aws_api_gateway_rest_api.content_api.id
  resource_id = aws_api_gateway_resource.generate.id
  http_method = aws_api_gateway_method.generate_post.http_method
  status_code = aws_api_gateway_method_response.generate_post_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,OPTIONS'"
  }

  depends_on = [aws_api_gateway_integration.generate_lambda]
}

# OPTIONS for /generate
resource "aws_api_gateway_method" "generate_options" {
  rest_api_id   = aws_api_gateway_rest_api.content_api.id
  resource_id   = aws_api_gateway_resource.generate.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "generate_options" {
  rest_api_id = aws_api_gateway_rest_api.content_api.id
  resource_id = aws_api_gateway_resource.generate.id
  http_method = aws_api_gateway_method.generate_options.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = jsonencode({ statusCode = 200 })
  }
}

resource "aws_api_gateway_method_response" "generate_options" {
  rest_api_id = aws_api_gateway_rest_api.content_api.id
  resource_id = aws_api_gateway_resource.generate.id
  http_method = aws_api_gateway_method.generate_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "generate_options" {
  rest_api_id = aws_api_gateway_rest_api.content_api.id
  resource_id = aws_api_gateway_resource.generate.id
  http_method = aws_api_gateway_method.generate_options.http_method
  status_code = aws_api_gateway_method_response.generate_options.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [aws_api_gateway_integration.generate_options]
}

# CORS for frontend
resource "aws_api_gateway_method" "options" {
  rest_api_id      = aws_api_gateway_rest_api.content_api.id
  resource_id      = aws_api_gateway_rest_api.content_api.root_resource_id
  http_method      = "OPTIONS"
  authorization    = "NONE"
}

resource "aws_api_gateway_integration" "options" {
  rest_api_id      = aws_api_gateway_rest_api.content_api.id
  resource_id      = aws_api_gateway_rest_api.content_api.root_resource_id
  http_method      = aws_api_gateway_method.options.http_method
  type             = "MOCK"
  request_templates = {
    "application/json" = jsonencode({ statusCode = 200 })
  }
}

resource "aws_api_gateway_method_response" "options" {
  rest_api_id      = aws_api_gateway_rest_api.content_api.id
  resource_id      = aws_api_gateway_rest_api.content_api.root_resource_id
  http_method      = aws_api_gateway_method.options.http_method
  status_code      = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "options" {
  rest_api_id = aws_api_gateway_rest_api.content_api.id
  resource_id = aws_api_gateway_rest_api.content_api.root_resource_id
  http_method = aws_api_gateway_method.options.http_method
  status_code = aws_api_gateway_method_response.options.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [aws_api_gateway_integration.options]
}

resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.prod.id
  rest_api_id   = aws_api_gateway_rest_api.content_api.id
  stage_name    = "prod"

  variables = {
    environment = var.environment
  }

  tags = {
    Name = "${var.project_name}-stage"
  }
}

resource "aws_api_gateway_deployment" "prod" {
  rest_api_id = aws_api_gateway_rest_api.content_api.id

  depends_on = [
    aws_api_gateway_integration.generate_lambda,
    aws_api_gateway_integration.history_lambda,
    aws_api_gateway_integration.options,
    aws_api_gateway_integration_response.generate_post_200,
    aws_api_gateway_integration_response.history_get_200,
    aws_api_gateway_integration_response.options,
    aws_api_gateway_integration_response.generate_options,
    aws_api_gateway_integration_response.history_options,
  ]
}

