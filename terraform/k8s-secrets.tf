# Secret para o banco de dados de produto
resource "kubernetes_secret" "db_product_secret" {
  metadata {
    name      = "ms-product-secret"
    namespace = "default"
  }

  data = {
    postgres_user = var.postgres_user_product
    postgres_password = var.postgres_password_product
    postgres_database = var.postgres_database_product
    postgres_host = split(":", aws_db_instance.postgres_rds_product.endpoint)[0]
  }

  depends_on = [ aws_eks_access_entry.access_entry, aws_eks_access_policy_association.eks-policy ]
}

# Secret para o banco de dados de pagamentos
resource "kubernetes_secret" "db_payment_secret" {
  metadata {
    name      = "ms-payment-secret"
    namespace = "default"
  }

  data = {
    postgres_user = var.postgres_user_payment
    postgres_password = var.postgres_password_payment
    postgres_database = var.postgres_database_payment
    postgres_host = split(":", aws_db_instance.postgres_rds_payment.endpoint)[0]
  }

  depends_on = [ aws_eks_access_entry.access_entry, aws_eks_access_policy_association.eks-policy ]
}

# Secret para o banco de dados de pedidos
resource "kubernetes_secret" "db_order_secret" {
  metadata {
    name      = "ms-order-secret"
    namespace = "default"
  }

  data = {
    aws_access_key_id     = var.aws_access_key_id
    aws_secret_access_key = var.aws_secret_access_key
    aws_region           = var.regionDefault
  }

  depends_on = [ aws_eks_access_entry.access_entry, aws_eks_access_policy_association.eks-policy ]
}