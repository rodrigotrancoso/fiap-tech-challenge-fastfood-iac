### RDS SUBNET GROUP ### 
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "my-rds-subnet-group-ms-product"
  subnet_ids = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]

  tags = {
    Name = "My RDS Subnet Group"
  }
}

### RDS Postgres para o serviço de produtos ###
resource "aws_db_instance" "postgres_rds_product" {
  identifier          = "product-postgres"
  engine              = "postgres"
  engine_version      = "16"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  storage_type        = "gp2"
  username            = var.postgres_user_product
  password            = var.postgres_password_product
  db_name             = var.postgres_database_product
  skip_final_snapshot = true

  publicly_accessible = true
  
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

### RDS Postgres para o serviço de produtos ###
resource "aws_db_instance" "postgres_rds_payment" {
  identifier          = "payment-postgres"
  engine              = "postgres"
  engine_version      = "16"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  storage_type        = "gp2"
  username            = var.postgres_user_payment
  password            = var.postgres_password_payment
  db_name             = var.postgres_database_payment
  skip_final_snapshot = true

  publicly_accessible = true

  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}