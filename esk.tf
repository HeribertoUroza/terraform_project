# Resource aws_iam_role
# Link: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role

resource "aws_iam_role" "eks_cluster" {
  name = "eks_cluster"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "EKS_Cluster"
  }
}

# --- POLICY ATTACHMENT 
# Resource aws_iam_role_policy_attachment
# Link: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  # (Required) - The name of the IAM role to which the policy should be applied
  role = aws_iam_role.eks_cluster.name

  # (Required) - The ARN of the policy you want to apply
  # Policy Info: https://console.aws.amazon.com/iam/home#/policies/arn:aws:iam::aws:policy/AmazonEKSClusterPolicy%24jsonEditor
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# --- EKS CLUSTER CREATION
# Resource aws_eks_cluster
# Link: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster

resource "aws_eks_cluster" "eks" {
  # (Required) Name of the cluster.
  name     = "aws_eks_cluster"

  #(Required) ARN of the IAM role that provides permissions for the Kubernetes control plane to make calls to AWS API operations on your behalf.
  role_arn = aws_iam_role.eks_cluster.arn

  # (Required) Configuration block for the VPC associated with your cluster. Amazon EKS VPC resources have specific requirements to work properly with Kubernetes.
  vpc_config {
    # (Optional) Whether the Amazon EKS public API server endpoint is enabled. Default is true.
    endpoint_public_access = true

    # (Optional) Whether the Amazon EKS private API server endpoint is enabled. Default is false.
    endpoint_private_access = false

    # Required) List of subnet IDs. Must be in at least two different availability zones. Amazon EKS creates cross-account elastic network interfaces in these subnets to allow communication between your worker nodes and the Kubernetes control plane.
    subnet_ids = [
        aws_subnet.terra_sub_public_1.id, 
        aws_subnet.terra_sub_public_2.id,
        aws_subnet.terra_sub_private_1.id,
        aws_subnet.terra_sub_private_2.id
        ]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}
