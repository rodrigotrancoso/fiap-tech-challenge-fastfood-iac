### DynamoDB para o serviço de pedidos ###
resource "aws_dynamodb_table" "order_table" {
  name         = "orders"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "orderId"

  attribute {
    name = "orderId"
    type = "S"
  }

  tags = {
    Name = "orders"
  }
}