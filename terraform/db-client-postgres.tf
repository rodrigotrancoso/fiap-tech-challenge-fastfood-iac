# Recurso para criar uma instância EC2 que funcionará como um bastion
# para acessar um banco de dados RDS em uma sub-rede privada
resource "aws_instance" "db_client" {
  ami                    = "ami-0ebfd941bbafe70c6"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.ssh_cluster_fastfood.id]
  subnet_id              = aws_subnet.public_subnet_a.id
  
   # Criar diretório antes de copiar os arquivos
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = tls_private_key.tls_private.private_key_pem
      host        = self.public_ip
    }

    inline = [
      "mkdir -p /home/ec2-user/init-postgres"
    ]
  }

  # Copia o arquivo SQL para a instância
  provisioner "file" {
    source      = "../init-postgres/"
    destination = "/home/ec2-user/init-postgres/"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = tls_private_key.tls_private.private_key_pem
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo dnf install -y postgresql15",  # Installs PostgreSQL client
      "export PGPASSWORD='${var.postgres_password_product}'",
      "psql -h ${aws_db_instance.postgres_rds_product.address} -U ${var.postgres_user_product} -d ${var.postgres_database_product} -f /home/ec2-user/init-postgres/init-product.sql",
      "export PGPASSWORD='${var.postgres_password_payment}'",
      "psql -h ${aws_db_instance.postgres_rds_payment.address} -U ${var.postgres_user_payment} -d ${var.postgres_database_payment} -f /home/ec2-user/init-postgres/init-payment.sql",
      ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = tls_private_key.tls_private.private_key_pem # Caminho para sua chave privada
      host        = self.public_ip                              # Se a instância for pública
    }
  }

  depends_on = [aws_db_instance.postgres_rds_product, aws_db_instance.postgres_rds_payment, aws_key_pair.generated_key]
}