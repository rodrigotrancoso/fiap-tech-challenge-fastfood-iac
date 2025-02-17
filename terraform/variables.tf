variable "postgres_user_product" {
  description = "MySQL User para o serviço de produto"
  type        = string
  default     = "product_user"
}

variable "postgres_password_product" {
  description = "MySQL Password para o serviço de produto"
  type        = string
  sensitive = true
}

variable "postgres_database_product" {
  description = "MySQL Database para o serviço de produto"
  type        = string
  default     = "product_db"
}

variable "postgres_user_payment" {
  description = "MySQL User para o serviço de produto"
  type        = string
  default     = "payment_user"
}

variable "postgres_password_payment" {
  description = "MySQL Password para o serviço de produto"
  type        = string
  sensitive = true
}

variable "postgres_database_payment" {
  description = "MySQL Database para o serviço de produto"
  type        = string
  default     = "payment_db"
}

variable "cluster_name" {
  description = "Cluster Name"
  type        = string
  default     = "fastfood-cluster"
}

variable "regionDefault" {
  default = "us-east-1"
}

variable "principalArn" {
  description = "Principal ARN"
  type        = string
  sensitive   = true
}

variable "aws_access_key_id" {
  description = "AWS Access Key ID"
  type        = string
  sensitive   = true
}

variable "aws_secret_access_key" {
  description = "AWS Secret Access Key"
  type        = string
  sensitive   = true
}