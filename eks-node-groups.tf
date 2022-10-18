# Resource aws_iam_role
# Link: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role

resource "aws_iam_role" "eks_node_group_role" {
  name = "eks_node_group_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "EKS_Node_Group_Role"
  }
}

# --- POLICY ATTACHMENT 
# Resource aws_iam_role_policy_attachment
# Link: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment

resource "aws_iam_role_policy_attachment" "aws_eks_WorkerNode_policy" {
  # (Required) - The name of the IAM role to which the policy should be applied
  role = aws_iam_role.eks_node_group_role.name

  # (Required) - The ARN of the policy you want to apply
  # Policy Info: https://us-east-1.console.aws.amazon.com/iam/home?region=us-east-1&skipRegion=true#/policies/arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy$jsonEditor
  # DESC: This policy allows Amazon EKS worker nodes to connect to Amazon EKS Clusters.
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "aws_eks_CNI_policy" {
  # (Required) - The name of the IAM role to which the policy should be applied
  role = aws_iam_role.eks_node_group_role.name

  # (Required) - The ARN of the policy you want to apply
  # Policy Info: https://us-east-1.console.aws.amazon.com/iam/home?region=us-east-1&skipRegion=true#/policies/arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy$jsonEditor
  # DESC: This policy provides the Amazon VPC CNI Plugin (amazon-vpc-cni-k8s) the permissions it requires to modify the IP address configuration on your EKS worker nodes.
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "aws_ec2_ContainerRegistry_ReadOnly_policy" {
  # (Required) - The name of the IAM role to which the policy should be applied
  role = aws_iam_role.eks_node_group_role.name

  # (Required) - The ARN of the policy you want to apply
  # Policy Info: https://docs.aws.amazon.com/AmazonECR/latest/userguide/security-iam-awsmanpol.html#security-iam-awsmanpol-AmazonEC2ContainerRegistryReadOnly
  # DESC: This policy grants read-only permissions to Amazon ECR. This includes the ability to list repositories and images within the repositories.
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Resource aws_eks_node_group
# Link: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group

resource "aws_eks_node_group" "EKS_nodes" {
  # (Required) Name of the EKS Cluster.
  cluster_name = aws_eks_cluster.eks.name

  # (Required) Amazon Resource Name (ARN) of the IAM Role that provides permissions for the EKS Node Group.
  node_role_arn = aws_iam_role.eks_node_group_role.arn

  # (Required) Identifiers of EC2 Subnets to associate with the EKS Node Group. These subnets must have the following resource tag: kubernetes.io/cluster/CLUSTER_NAME (where CLUSTER_NAME is replaced with the name of the EKS Cluster).
  subnet_ids = [
    aws_subnet.terra_sub_private_1.id,
    aws_subnet.terra_sub_private_2.id
  ]

  #(Optional) Name of the EKS Node Group. If omitted, Terraform will assign a random, unique name.
  node_group_name = "EKS_nodes"

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  # (Optional) Type of Amazon Machine Image (AMI) associated with the EKS Node Group. 
  # The only Valid Values: AL2_x86_64 | AL2_x86_64_GPU | AL2_ARM_64 | CUSTOM | BOTTLEROCKET_ARM_64 | BOTTLEROCKET_x86_64 | BOTTLEROCKET_ARM_64_NVIDIA | BOTTLEROCKET_x86_64_NVIDIA
  ami_type = "AL2_x86_64"

  # (Optional) Type of capacity associated with the EKS Node Group.
  # The only Valid Values: ON_DEMAND | SPOT
  capacity_type = "SPOT" # Cheaper Option. Not intended for mission critical workloads

  # (Optional) Disk size in GiB for worker nodes. Defaults to 20.
  disk_size = 20

  # (Optional) Force version update if existing pods are unable to be drained due to a pod disruption budget issue.
  force_update_version = false

  # (Optional) List of instance types associated with the EKS Node Group. Defaults to ["t3.medium"].
  instance_types = ["t3.small"] # Smaller cheaper option

  # (Optional) Key-value map of Kubernetes labels. Only labels that are applied with the EKS API are managed by this argument.
  labels = {
    role = "EKS_nodes"
  }

  # (Optional) Kubernetes version. Defaults to EKS Cluster Kubernetes version.
  # version = "" Leaving blank to use default value

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.aws_eks_WorkerNode_policy,
    aws_iam_role_policy_attachment.aws_eks_CNI_policy,
    aws_iam_role_policy_attachment.aws_ec2_ContainerRegistry_ReadOnly_policy,
  ]
}
