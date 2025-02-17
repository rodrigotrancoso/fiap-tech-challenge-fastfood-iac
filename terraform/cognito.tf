# Cognito User Pool
resource "aws_cognito_user_pool" "fastfood_user_pool" {
  name = "fastfood-user-pool"

  schema {
    name                = "cpf"
    attribute_data_type = "String"
    mutable             = true
    required            = false
  }

  # Se quiser validar automaticamente o e-mail, adicione "email" aqui
  auto_verified_attributes = [] # Estamos apenas verificando o CPF
}

# Cognito User Pool Client
resource "aws_cognito_user_pool_client" "fastfood_app_client" {
  name         = "fastfood-app-client"
  user_pool_id = aws_cognito_user_pool.fastfood_user_pool.id

  generate_secret = false

  # Definindo um fluxo de autenticação personalizado
  explicit_auth_flows = [
    "ALLOW_CUSTOM_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH"
  ]

  # Definindo a validade dos tokens
  access_token_validity  = 1  # Validade do token de acesso em minutos
  id_token_validity      = 1  # Validade do token de ID em minutos
  refresh_token_validity = 60 # Validade do token de atualização em dias

  depends_on = [aws_cognito_user_pool.fastfood_user_pool]
}

# Cognito User
# Cognito User
resource "aws_cognito_user" "fastfood_user" {
  user_pool_id = aws_cognito_user_pool.fastfood_user_pool.id
  username     = "fiap-test"
  attributes = {
    email       = "fiap@test.com"
    cpf         = "12345678900"
  }
  temporary_password = "@temporaryPass123"
  force_alias_creation = false
  message_action = "SUPPRESS"
  lifecycle {
    ignore_changes = [
      attributes,
      temporary_password,
      username
    ]
  }

  depends_on = [aws_cognito_user_pool.fastfood_user_pool] # 🚀 Garante que o user pool está pronto antes de criar o usuário
}

# Definir a senha permanente para o usuário
resource "null_resource" "set_user_password" {
  provisioner "local-exec" {
    command = <<EOT
      aws cognito-idp admin-set-user-password --user-pool-id ${aws_cognito_user_pool.fastfood_user_pool.id} --username fiap-test --password "@temporaryPass123" --permanent
    EOT
  }

  depends_on = [aws_cognito_user.fastfood_user]
}
