# Resource aws_internet_gateway
# Link: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway

resource "aws_internet_gateway" "terra_igw" {
  # Required parameter
  vpc_id = aws_vpc.terra_vpc.id

  tags = {
    Name = "Terraform IGW"
  }
}