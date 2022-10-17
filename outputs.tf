output "terra_vpc_id" {
    value = aws_vpc.terra_vpc.id
    description = "Terraform VPC ID"
}