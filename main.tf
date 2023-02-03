resource "aws_vpc" "My-VPC-DEV" {
  cidr_block           = var.cidr_range
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  #tags = var.tags
     tags = {
    Name = "my-new-vpc"
  }
}
# Creating an Internet Gateway
resource "aws_internet_gateway" "igw" {
  count = var.enabled && length(var.vpc-public-subnet-cidr) > 0 ? 1 : 0
  vpc_id = aws_vpc.My-VPC-DEV.id
    tags = {
    Name = "public-igw-${count.index}"
  }
}
# Public Subnets
resource "aws_subnet" "public-subnets" {
  count                   = length(var.vpc-public-subnet-cidr)
  availability_zone       = var.availability_zone[count.index]
  cidr_block              = var.vpc-public-subnet-cidr[count.index]
  vpc_id                  = aws_vpc.My-VPC-DEV.id
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags = {
    Name = "public-subnet-${count.index}"
  }
}
# Public Routes
resource "aws_route_table" "public-routes" {
  vpc_id = aws_vpc.My-VPC-DEV.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[0].id
  }
    tags = {
    Name = "public-subnet-route"
  }
}
# Associate/Link Public-Route With Public-Subnets

resource "aws_route_table_association" "public-association" {
  count          = var.enabled && length(var.vpc-public-subnet-cidr) > 0 ? length(var.vpc-public-subnet-cidr) : 0
  route_table_id = aws_route_table.public-routes.id
  subnet_id      = aws_subnet.public-subnets.*.id[count.index]
}

# Creating Private Subnets
resource "aws_subnet" "private-subnets" {
  count                   = length(var.vpc-private-subnet-cidr)
  availability_zone       = var.availability_zone[count.index]
  cidr_block              = var.vpc-private-subnet-cidr[count.index]
  vpc_id                  = aws_vpc.My-VPC-DEV.id
  tags = {
    Name = "private-subnet-${count.index}"
  }
}

# Elastic IP For NAT-Gate Way
resource "aws_eip" "eip-ngw" {
  count = var.enabled && var.total-nat-gateway-required > 0 ?  var.total-nat-gateway-required : 0
    tags = {
    Name = "private-nat-ip-${count.index}"
  }
}
# Creating NAT Gateways In Public-Subnets, Each NAT-Gateway Will Be In Diffrent AZ

resource "aws_nat_gateway" "ngw" {
  count         = var.enabled && var.total-nat-gateway-required > 0 ? var.total-nat-gateway-required : 0
  allocation_id = aws_eip.eip-ngw.*.id[count.index]
  subnet_id     = aws_subnet.public-subnets.*.id[count.index]
    tags = {
    Name = "private-nat-${count.index}"
  }
}

# Private Route-Table For Private-Subnets

resource "aws_route_table" "private-routes" {
  count  = var.enabled && length(var.vpc-private-subnet-cidr) > 0 ? length(var.vpc-private-subnet-cidr) : 0
  vpc_id = aws_vpc.My-VPC-DEV.id
  route {
    cidr_block     = var.private-route-cidr
    nat_gateway_id = element(aws_nat_gateway.ngw.*.id,count.index)
  }
    tags = {
    Name = "private-subnet-route"
  }
}
# Associate/Link Private-Routes With Private-Subnets

resource "aws_route_table_association" "private-routes-linking" {
  count          = var.enabled && length(var.vpc-private-subnet-cidr) > 0 ? length(var.vpc-private-subnet-cidr) : 0
  subnet_id      = aws_subnet.private-subnets.*.id[count.index]
  route_table_id = aws_route_table.private-routes.*.id[count.index]
}