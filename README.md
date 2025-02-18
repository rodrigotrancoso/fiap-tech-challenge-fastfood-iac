# 🍔 FastFood - Sistema de Autoatendimento Inteligente

A FastFood é uma lanchonete de bairro que está crescendo rapidamente devido ao seu grande sucesso. No entanto, com a expansão, a gestão de pedidos tornou-se um desafio, resultando em confusões na cozinha, atrasos na entrega e clientes insatisfeitos. Para resolver esse problema, desenvolvemos um **sistema de autoatendimento baseado em microserviços e infraestrutura escalável na AWS**.

## 🎯 Solução
O sistema de autoatendimento da FastFood foi projetado para garantir que os pedidos sejam feitos com precisão, gerenciados de forma eficiente e entregues sem falhas. Ele possui as seguintes funcionalidades:

✅ **Pedido Online:** Os clientes podem montar combos personalizados diretamente na interface, escolhendo:
- Lanche
- Acompanhamento
- Bebida

✅ **Pagamento Integrado:** Através de um QR Code gerado pelo Mercado Pago, garantindo praticidade e segurança.

✅ **Rastreamento de Pedido:** O cliente pode acompanhar seu pedido em tempo real nas seguintes etapas:
- Recebido
- Em preparação
- Pronto
- Finalizado

✅ **Gestão Inteligente:** O estabelecimento pode:
- Gerenciar clientes e campanhas promocionais
- Controlar produtos e categorias (Lanches, Acompanhamentos, Bebidas e Sobremesas)
- Monitorar pedidos em andamento e tempos de espera

Para tornar essa solução possível, desenvolvemos **três microsserviços principais** e toda a infraestrutura necessária para operá-los de forma escalável e segura na AWS.

---

# 🏗️ Infraestrutura como Código (IaC)

Utilizamos **Terraform** para provisionar toda a infraestrutura na AWS, garantindo **automação, escalabilidade e segurança**. O sistema é composto pelos seguintes microsserviços:

- **[MS de Produtos](https://github.com/rodrigotrancoso/fiap-tech-challenge-ms-product)** → Gerencia os produtos e se conecta ao **RDS PostgreSQL**.
- **[MS de Pedidos](https://github.com/rodrigotrancoso/fiap-tech-challenge-ms-order)** → Gerencia os pedidos e utiliza o **DynamoDB** para armazenamento.
- **[MS de Pagamentos](https://github.com/rodrigotrancoso/fiap-tech-challenge-ms-payment)** → Processa pagamentos e se conecta ao **RDS PostgreSQL e MercadoPago**.

---

## 🚀 Tecnologias Utilizadas
- **Terraform** - Infraestrutura como código
- **AWS EKS** - Cluster Kubernetes para microsserviços
- **AWS RDS PostgreSQL** - Banco relacional para produtos e pagamentos
- **AWS DynamoDB** - Banco NoSQL para pedidos
- **AWS API Gateway** - Roteamento de chamadas HTTP
- **AWS Cognito** - Autenticação de usuários
- **AWS Lambda** - Funções serverless
- **AWS VPC** - Rede isolada para segurança
- **GitHub Actions** - CI/CD para automação de deploys

---

## 📂 Estrutura do Repositório
```
📁 fiap-tech-challenge-fastfood-iac
├── 📁 terraform
│   ├── 📜 provider.tf  # Configuração do provedor AWS
│   ├── 📜 vpc.tf  # Configuração da Virtual Private Cloud (VPC) e subnets
│   ├── 📜 eks.tf  # Cluster Kubernetes (EKS) para rodar os microserviços
│   ├── 📜 db-postgres.tf  # Banco de dados RDS PostgreSQL
│   ├── 📜 db-order-dynamodb.tf  # Banco DynamoDB para pedidos
│   ├── 📜 api-gateway.tf  # API Gateway para roteamento de chamadas HTTP
│   ├── 📜 cognito.tf  # AWS Cognito para autenticação
│   ├── 📜 iamrole-for-db-postgres.tf  # IAM para acesso ao RDS
│   ├── 📜 keypair.tf  # Chave SSH para acesso a instâncias
│   ├── 📜 outputs.tf  # Definição das saídas do Terraform
│   ├── 📜 variables.tf  # Variáveis para configuração da infraestrutura
├── 📁 k8s
│   ├── 📜 k8s-secrets.tf  # Secrets para armazenar credenciais de banco
├── 📁 init-postgres
│   ├── 📜 init-product.sql  # Script de inicialização do BD de Produtos
│   ├── 📜 init-payment.sql  # Script de inicialização do BD de Pagamentos
├── 📁 .github/workflows
│   ├── 📜 provisione-iac.yml  # CI/CD para provisionamento da infraestrutura
│   ├── 📜 destroy-iac.yml  # CI/CD para destruição da infraestrutura
├── 📜 README.md
```

---

## 🔧 Como Provisionar a Infraestrutura

### 1️⃣ **Instalar Dependências**
Certifique-se de ter instalado:
- [Terraform](https://www.terraform.io/downloads)
- [AWS CLI](https://aws.amazon.com/cli/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

### 2️⃣ **Configurar Credenciais da AWS**
Autentique-se na AWS com:
```sh
aws configure
```

### 3️⃣ **Inicializar o Terraform**
```sh
terraform init
```

### 4️⃣ **Criar um Plano de Execução**
```sh
terraform plan -out=tfplan
```

### 5️⃣ **Aplicar a Infraestrutura**
```sh
terraform apply tfplan
```

---

## 📌 Recursos Criados
- **VPC** com subnets públicas e privadas.
- **Cluster Kubernetes (EKS)** para os microserviços.
- **AWS RDS PostgreSQL** para produtos e pagamentos.
- **AWS DynamoDB** para pedidos.
- **AWS API Gateway** para roteamento de chamadas HTTP.
- **AWS Cognito** para autenticação de usuários.
- **IAM Roles e Policies** para controle de acesso.
- **Secrets no Kubernetes** para armazenar credenciais.

---

## 🚢 CI/CD com GitHub Actions
Este repositório possui **CI/CD** automatizado:
- **`provisione-iac.yml`** → Provisiona a infraestrutura na AWS via Terraform.
- **`destroy-iac.yml`** → Destrói a infraestrutura provisionada.

---

## 🗑️ Como Remover a Infraestrutura
```sh
terraform destroy -auto-approve
```

---

