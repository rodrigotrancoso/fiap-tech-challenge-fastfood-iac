# Role que permite que o Lambda acesse o Cognito
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_lambda_function" "auth_function" {
  function_name = "authFunction"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  filename      = "${path.module}/../lambda/lambda_function.zip" # Caminho absoluto do arquivo ZIP
  #source_code_hash = filebase64sha256("/home/raf/Desktop/pos-fiap/fase2/Grupo-34-8SOAT-FIAP/lambda/lambda_function.zip") # Calcula o hash do código

  environment {
    variables = {
      COGNITO_USER_POOL_ID = aws_cognito_user_pool.fastfood_user_pool.id         # Referência ao Cognito User Pool ID
      COGNITO_CLIENT_ID    = aws_cognito_user_pool_client.fastfood_app_client.id # Referência ao Cognito Client ID
    }
  }

  timeout = 10 # Aumenta o timeout para 10 segundos

  lifecycle {
    create_before_destroy = true
  }
}