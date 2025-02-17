# Configuração do Terraform para usar o Amazon S3 como backend onde o estado do Terraform será salvo.
terraform {
  backend "s3" {
    bucket = "terraform-state-fastfood"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}