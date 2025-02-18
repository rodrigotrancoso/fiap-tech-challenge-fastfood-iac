resource "aws_eks_cluster" "cluster-k8s" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  vpc_config {
    subnet_ids         = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]
    security_group_ids = [aws_security_group.ssh_cluster_fastfood.id]
  }

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }
}

resource "aws_eks_node_group" "node-group" {
  cluster_name    = aws_eks_cluster.cluster-k8s.name
  node_group_name = "NG-${var.cluster_name}"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]
  instance_types  = ["t3.medium"]
  disk_size       = 50

  scaling_config {
    desired_size = 2
    max_size     = 5
    min_size     = 2
  }

  update_config {
    max_unavailable = 1
  }
}

#### IAM ROLES ####

# Define um Role IAM que o Amazon EKS usará para assumir permissões
resource "aws_iam_role" "eks_role" {
  name = "eks-cluster-role" # Nome do Role IAM para o cluster EKS

  # Política de AssumeRole que permite ao serviço EKS assumir este Role
  assume_role_policy = jsonencode({
    Version = "2012-10-17", # Versão da política de assume role
    Statement = [
      {
        Effect = "Allow", # Permite a ação
        Principal = {
          Service = "eks.amazonaws.com", # O serviço EKS é o principal que pode assumir este Role
        },
        Action = "sts:AssumeRole", # Ação permitida é assumir o Role
      },
    ],
  })
}

#### IAM POLICIES ####

# Associate IAM Policy to IAM Role
resource "aws_iam_role_policy_attachment" "eks-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

# Define um Role IAM para os nós do EKS
resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = ["eks.amazonaws.com", "ec2.amazonaws.com"]
        },
        Action = "sts:AssumeRole",
      },
    ],
  })
}


# Anexa a política ao role dos nós do EKS
resource "aws_iam_role_policy_attachment" "eks_fastfood_node_ecr_policy_attachment" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy" #aws_iam_policy.eks_restaurante_node_ecr_policy.arn
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ec2_container_registry_read_only" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_eks_access_entry" "access_entry" {
  cluster_name      = aws_eks_cluster.cluster-k8s.name
  principal_arn     = var.principalArn
  kubernetes_groups = ["k8s"]
  type              = "STANDARD"
}

resource "aws_eks_access_policy_association" "eks-policy" {
  cluster_name  = aws_eks_cluster.cluster-k8s.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = var.principalArn

  access_scope {
    type = "cluster"
  }
}