# Resource aws_eip
# Link: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip

resource "aws_eip" "nat_1" {

  # EIP may require IGW to exist prior to association. Use depends_on to set an explicit dependency on the IGW.
  depends_on = [
    aws_internet_gateway.terra_igw
  ]
}

resource "aws_eip" "nat_2" {

  # EIP may require IGW to exist prior to association. Use depends_on to set an explicit dependency on the IGW.
  depends_on = [
    aws_internet_gateway.terra_igw
  ]
}