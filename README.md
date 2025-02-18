# 🏗️ FIAP Tech Challenge - Infraestrutura como Código (IaC)

Este repositório contém toda a infraestrutura necessária para rodar os **três microserviços** do FIAP Tech Challenge, utilizando **Terraform** para provisionar recursos na AWS.

Os microserviços disponíveis são:

- **MS de Produtos** [(fiap-tech-challenge-ms-product)](https://github.com/rodrigotrancoso/fiap-tech-challenge-ms-product) → Banco RDS PostgreSQL.
- **MS de Pedidos** [(fiap-tech-challenge-ms-order)](https://github.com/rodrigotrancoso/fiap-tech-challenge-ms-order) → Banco DynamoDB.
- **MS de Pagamentos** [(fiap-tech-challenge-ms-payment)](https://github.com/rodrigotrancoso/fiap-tech-challenge-ms-payment) → Banco RDS PostgreSQL e integração com MercadoPago.

---

## 🚀 Tecnologias Utilizadas
- **Terraform** - Infraestrutura como código
- **AWS EKS** - Cluster Kubernetes
- **AWS RDS PostgreSQL** - Banco relacional
- **AWS DynamoDB** - Banco NoSQL
- **AWS API Gateway** - Roteamento de chamadas
- **AWS Cognito** - Autenticação
- **AWS Lambda** - Execução de funções serverless
- **AWS VPC** - Rede isolada para os serviços
- **GitHub Actions** - CI/CD

---

## 📂 Estrutura do Repositório
```
📁 fiap-tech-challenge-fastfood-iac
├── 📁 terraform
│   ├── 📜 provider.tf  # Configuração do provedor AWS
│   ├── 📜 vpc.tf  # Configuração da Virtual Private Cloud (VPC) e subnets
│   ├── 📜 eks.tf  # Cluster Kubernetes (EKS) para rodar os microserviços
│   ├── 📜 db-postgres.tf  # Banco de dados RDS PostgreSQL para os MS de Produtos e Pagamentos
│   ├── 📜 db-order-dynamodb.tf  # Banco de dados DynamoDB para o MS de Pedidos
│   ├── 📜 api-gateway.tf  # Configuração do API Gateway para roteamento de chamadas HTTP
│   ├── 📜 cognito.tf  # Configuração do AWS Cognito para autenticação dos usuários
│   ├── 📜 iamrole-for-db-postgres.tf  # IAM para acesso ao RDS pelos serviços no Kubernetes
│   ├── 📜 keypair.tf  # Criação de chave SSH para acesso a instâncias, se necessário
│   ├── 📜 outputs.tf  # Definição das saídas do Terraform (ex.: endpoints gerados)
│   ├── 📜 variables.tf  # Definição de variáveis para parametrizar a infraestrutura
├── 📁 k8s
│   ├── 📜 k8s-secrets.tf  # Secrets para conexão aos bancos de dados
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
No diretório onde estão os arquivos do Terraform, execute:
```sh
terraform init
```
Este comando baixa os plugins necessários e prepara o ambiente para a execução.

### 4️⃣ **Criar um Plano de Execução**
```sh
terraform plan -out=tfplan
```
Isso cria um plano detalhado de todas as alterações que o Terraform fará na AWS, ajudando a visualizar os recursos antes da criação.

### 5️⃣ **Aplicar a Infraestrutura**
```sh
terraform apply tfplan
```
Este comando cria todos os recursos descritos nos arquivos do Terraform.

---

## 📌 Recursos Criados
A infraestrutura criada pelo Terraform inclui:

### ✅ **Virtual Private Cloud (VPC)**
- Criada para isolar e organizar a comunicação entre os serviços.
- Contém **subnets públicas e privadas** para diferentes recursos.
- Associada a um **Internet Gateway** para permitir acesso externo.

### ✅ **Cluster Kubernetes (EKS)**
- Um cluster gerenciado pela AWS para rodar os três microserviços.
- Configuração de segurança para acesso restrito e comunicação entre os serviços.

### ✅ **Banco de Dados AWS RDS PostgreSQL**
- Criado para armazenar os dados dos MS de Produtos e MS de Pagamentos.
- Configurado em subnets privadas para segurança.

### ✅ **Banco de Dados AWS DynamoDB**
- Criado para armazenar pedidos no MS de Pedidos.
- Operação altamente escalável e gerenciada pela AWS.

### ✅ **AWS API Gateway**
- Criado para rotear as chamadas HTTP entre os clientes e os microserviços.
- Mapeia os endpoints `/products`, `/orders` e `/payments` para os serviços correspondentes.

### ✅ **AWS Cognito**
- Gerencia autenticação e autorização de usuários.
- Permite que os serviços autentiquem chamadas protegidas.

### ✅ **AWS IAM Roles e Policies**
- Permissões configuradas para os serviços acessarem os bancos de dados.
- Roles específicas para integração segura entre os serviços e a infraestrutura.

### ✅ **Secrets no Kubernetes**
- Secrets criados no Kubernetes para armazenar credenciais dos bancos de dados.
- Garantia de segurança no armazenamento de dados sensíveis.

---

## 🚢 CI/CD com GitHub Actions
Este repositório possui **CI/CD** automatizado:
- **`provisione-iac.yml`** → Provisiona a infraestrutura na AWS via Terraform.
- **`destroy-iac.yml`** → Destrói a infraestrutura provisionada.

---

## 🗑️ Como Remover a Infraestrutura
Para destruir todos os recursos criados na AWS, execute:
```sh
terraform destroy -auto-approve
```
Isso remove completamente todos os serviços provisionados pelo Terraform.

---

