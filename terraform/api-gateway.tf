# API Gateway REST API
resource "aws_api_gateway_rest_api" "api_gateway" {
  name        = "AuthAPI"
  description = "API de autenticação para o Fastfood"
}

# Recurso /auth no API Gateway
resource "aws_api_gateway_resource" "auth_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "auth"
}

# Definindo o Authorizer Cognito
resource "aws_api_gateway_authorizer" "cognito_authorizer" {
  name                    = "CognitoAuthorizer"
  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
  type                    = "COGNITO_USER_POOLS"   # Usando Cognito como autorizer
  provider_arns           = [aws_cognito_user_pool.fastfood_user_pool.arn]
  identity_source         = "method.request.header.Authorization"  # A chave do cabeçalho do JWT
}

# Método GET para o recurso /auth
resource "aws_api_gateway_method" "auth_method" {
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.auth_resource.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS" # A autenticação é feita via Cognito
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

# Integração do método com a função Lambda
resource "aws_api_gateway_integration" "auth_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
  resource_id             = aws_api_gateway_resource.auth_resource.id
  http_method             = aws_api_gateway_method.auth_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.regionDefault}:lambda:path/2015-03-31/functions/${aws_lambda_function.auth_function.arn}/invocations"
}

# Permissão para o API Gateway invocar o Lambda
resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = aws_lambda_function.auth_function.function_name
}

# Deployment do API Gateway
resource "aws_api_gateway_deployment" "api_gateway_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id

  triggers = {
    redeploy = "${timestamp()}"
  }

  depends_on = [
    aws_api_gateway_method.auth_method,       # Garante que o método existe antes do deployment
    aws_api_gateway_integration.auth_integration # Garante que a integração existe antes do deployment
  ]

  lifecycle {
    create_before_destroy = true  # Para garantir que o deployment seja atualizado corretamente
  }
}
