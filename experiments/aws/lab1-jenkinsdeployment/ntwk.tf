## Create the Main VPC
resource "aws_vpc" "jenkins_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true


  tags = merge(var.default_tags, {
    Name = "jenkins_vpc"
  })
}

## Create the Subnet to Launch Instances in

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.jenkins_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = merge(var.default_tags, {
    Name = "public-subnet-1"
  })
}

##VPC Create Routes

resource "aws_route" "toIGW" {
  route_table_id         = aws_vpc.jenkins_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.jenkins_igw.id
}

### Create the IGW

resource "aws_internet_gateway" "jenkins_igw" {
  vpc_id = aws_vpc.jenkins_vpc.id
  tags = merge(var.default_tags, {
    Name = "jenkins_igw"
  })
}

## ALL OUTPUTS

output "cidr_block" {
  value = aws_vpc.jenkins_vpc.cidr_block
}
output "main_route_table_id" {
  value = aws_vpc.jenkins_vpc.main_route_table_id
}
output "public_subnet_id" {
  value = aws_subnet.public_1.id
}
output "public_subnet_id_cidr" {
  value = aws_subnet.public_1.cidr_block
}

output "vpc_default_security_group_id" {
  value = aws_vpc.jenkins_vpc.default_security_group_id
}