# Resource aws_vpc
# Link: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc

resource "aws_vpc" "terra_vpc" {
  # The CIDR range for VPC
  cidr_block = "10.0.0.0/16"

  # Makes instances shared on the host
  instance_tenancy = "default"

  # Needed for EKS. A boolean flag to enable/disable DNS support in the VPC. Defaults true.
  enable_dns_support = true

  # Needed for EKS. A boolean flag to enable/disable DNS hostnames in the VPC. Defaults false.
  enable_dns_hostnames = true

  tags = {
    Name = "terra_vpc"
  }
}
