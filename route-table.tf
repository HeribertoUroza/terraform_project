# Resource aws_route_table
# Link: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table

resource "aws_route_table" "public_terra_RT" {
  # Required patameter
  vpc_id = aws_vpc.terra_vpc.id

  route {
    # CIDR of the route. all IPv4 addresses on the local machine
    cidr_block = "0.0.0.0/0"
    # Specify IGW
    gateway_id = aws_internet_gateway.terra_igw.id
  }

  tags = {
    Name = "public_terra_RT"
  }
}

resource "aws_route_table" "private_terra_RT_1" {
  # Required patameter
  vpc_id = aws_vpc.terra_vpc.id

  route {
    # CIDR of the route. all IPv4 addresses on the local machine
    cidr_block = "0.0.0.0/0"
    # Specify NAT GATWAY
    nat_gateway_id = aws_nat_gateway.nat_gw_1.id
  }

  tags = {
    Name = "private_terra_RT_1"
  }
}

resource "aws_route_table" "private_terra_RT_2" {
  # Required patameter
  vpc_id = aws_vpc.terra_vpc.id

  route {
    # CIDR of the route. all IPv4 addresses on the local machine
    cidr_block = "0.0.0.0/0"
    # Specify NAT GATWAY
    nat_gateway_id = aws_nat_gateway.nat_gw_2.id
  }

  tags = {
    Name = "private_terra_RT_2"
  }
}

#--- ROUTE TABLE ASSOCIATION
# Resource aws_route_table_association
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association

resource "aws_route_table_association" "public_terra_RTA1" {
  subnet_id      = aws_subnet.terra_sub_public_1.id
  route_table_id = aws_route_table.public_terra_RT.id
}

resource "aws_route_table_association" "public_terra_RTA2" {
  subnet_id      = aws_subnet.terra_sub_public_2.id
  route_table_id = aws_route_table.public_terra_RT.id
}

resource "aws_route_table_association" "private_terra_RT_1" {
  subnet_id      = aws_subnet.terra_sub_private_1.id
  route_table_id = aws_route_table.private_terra_RT_1.id
}

resource "aws_route_table_association" "private_terra_RT_2" {
  subnet_id      = aws_subnet.terra_sub_private_2.id
  route_table_id = aws_route_table.private_terra_RT_2.id
}
