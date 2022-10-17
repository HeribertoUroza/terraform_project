# Resource aws_nat_gateway
# Link: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway

resource "aws_nat_gateway" "nat_gw_1" {
  # The allocation_id of the EIP for the gateway.
  allocation_id = aws_eip.nat_1.id
  # The Subnet ID in which to place the gateway.
  subnet_id = aws_subnet.terra_sub_public_1.id

  tags = {
    Name = "NAT_gw_1_public"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  # depends_on = [aws_internet_gateway.terra_igw]
}

resource "aws_nat_gateway" "nat_gw_2" {
  # The allocation_id of the EIP for the gateway.
  allocation_id = aws_eip.nat_2.id
  # The Subnet ID in which to place the gateway.
  subnet_id = aws_subnet.terra_sub_public_2.id

  tags = {
    Name = "NAT_gw_2_public"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  # depends_on = [aws_internet_gateway.terra_igw]
}
