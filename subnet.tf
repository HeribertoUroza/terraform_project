# Resource aws_subnet
# Link: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet

resource "aws_subnet" "terra_sub_public_1" {
  # Required vpc_id & cidr_block 
  vpc_id     = aws_vpc.terra_vpc.id
  cidr_block = "10.0.0.0/19"

  # Specifying AZ
  availability_zone = "us-east-1a"

  # Required for EKS for public subnets
  map_public_ip_on_launch = true

  # The Kubernetes tag is needed to identify a cluster's subnets
  # Link: https://aws.amazon.com/premiumsupport/knowledge-center/eks-vpc-subnet-discovery/

  tags = {
    Name                                    = "terra_sub_public_1"
    "kubernetes.io/cluster/aws_eks_cluster" = "shared"
    "kubernetes.io/role/elb"                = 1
  }
}

resource "aws_subnet" "terra_sub_public_2" {
  # Required vpc_id & cidr_block 
  vpc_id     = aws_vpc.terra_vpc.id
  cidr_block = "10.0.32.0/19"

  # Specifying AZ
  availability_zone = "us-east-1b"

  # Required for EKS for public subnets
  map_public_ip_on_launch = true

  # The Kubernetes tag is needed to identify a cluster's subnets
  # Link: https://aws.amazon.com/premiumsupport/knowledge-center/eks-vpc-subnet-discovery/

  tags = {
    Name                                    = "terra_sub_public_2"
    "kubernetes.io/cluster/aws_eks_cluster" = "shared"
    "kubernetes.io/role/elb"                = 1
  }
}

resource "aws_subnet" "terra_sub_private_1" {
  # Required vpc_id & cidr_block 
  vpc_id     = aws_vpc.terra_vpc.id
  cidr_block = "10.0.64.0/19"

  # Specifying AZ
  availability_zone = "us-east-1a"


  # The Kubernetes tag is needed to identify a cluster's subnets
  # Link: https://aws.amazon.com/premiumsupport/knowledge-center/eks-vpc-subnet-discovery/

  tags = {
    Name                                    = "terra_sub_private_1"
    "kubernetes.io/cluster/aws_eks_cluster" = "shared"
    "kubernetes.io/role/internal-elb"       = 1
  }
}

resource "aws_subnet" "terra_sub_private_2" {
  # Required vpc_id & cidr_block 
  vpc_id     = aws_vpc.terra_vpc.id
  cidr_block = "10.0.96.0/19"

  # Specifying AZ
  availability_zone = "us-east-1b"


  # The Kubernetes tag is needed to identify a cluster's subnets
  # Link: https://aws.amazon.com/premiumsupport/knowledge-center/eks-vpc-subnet-discovery/

  tags = {
    Name                                    = "terra_sub_private_2"
    "kubernetes.io/cluster/aws_eks_cluster" = "shared"
    "kubernetes.io/role/internal-elb"       = 1
  }
}
