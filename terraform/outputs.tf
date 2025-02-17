output "gateway_url" {
  value = "https://${aws_api_gateway_rest_api.api_gateway.id}.execute-api.${var.regionDefault}.amazonaws.com/"
  description = "URL pública do API Gateway"
}

output "cognito_user_pool_id" {
  value       = aws_cognito_user_pool.fastfood_user_pool.id # ID do Cognito User Pool
  description = "ID do Cognito User Pool"
}

# Outputs
output "cognito_username" {
  value = aws_cognito_user.fastfood_user.username
}

output "cognito_temporary_password" {
  value     = aws_cognito_user.fastfood_user.temporary_password
  sensitive = true
}

output "postgres_rds_product_endpoint" {
  value = aws_db_instance.postgres_rds_product.endpoint
}

output "postgres_rds_payment_endpoint" {
  value = aws_db_instance.postgres_rds_payment.endpoint
}
