terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.3"
    }
  }
}

provider "aws" {
  region = var.regionDefault
}

data "aws_eks_cluster" "default" {
  name       = var.cluster_name
  depends_on = [aws_eks_cluster.cluster-k8s]
}

data "aws_eks_cluster_auth" "default" {
  name       = var.cluster_name
  depends_on = [aws_eks_cluster.cluster-k8s]
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.default.token
}
