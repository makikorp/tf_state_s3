
locals {
  azs = data.aws_availability_zones.available.names
}

data "aws_availability_zones" "available" {}

resource "random_id" "random" {
  byte_length =2
}

resource "aws_vpc" "eric_main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev-vpc-${random_id.random.dec}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "eric_public_subnet" {
  count                   = length(var.public_cidrs)
  vpc_id                  = aws_vpc.eric_main_vpc.id
  cidr_block             = cidrsubnet(var.vpc_cidr, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone = local.azs[count.index] # - uses local value defined above

  tags = {
    Name = "dev-public-subnet"
  }
}

resource "aws_subnet" "eric_private_subnet" {
  count                   = length(var.private_cidrs)
  vpc_id                  = aws_vpc.eric_main_vpc.id
  cidr_block             = cidrsubnet(var.vpc_cidr, 8, count.index + length(local.azs))
  map_public_ip_on_launch = false
  availability_zone = local.azs[count.index]

  tags = {
    Name = "dev-private-subnet"
  }
}


resource "aws_internet_gateway" "eric_internet_gateway" {
  vpc_id = aws_vpc.eric_main_vpc.id

  tags = {
    Name = "dev-internetgateway-${random_id.random.dec}"
  }
}

resource "aws_route_table" "eric_public_rt" {
  vpc_id = aws_vpc.eric_main_vpc.id

  tags = {
    Name = "dev-public-rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.eric_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.eric_internet_gateway.id
}

resource "aws_default_route_table" "eric_private_rt" {
  default_route_table_id = aws_vpc.eric_main_vpc.default_route_table_id

  tags = {
    Name = "eric_private_rt"
  }
}

resource "aws_route_table_association" "eric_public_assoc" {
  count = length(local.azs)
  subnet_id     = aws_subnet.eric_public_subnet.*.id[0] #[count.index]  
  route_table_id = aws_route_table.eric_public_rt.id
}

#private submets default to the default route table.  Private subnet doesn't need to have
#the association explicitly declared

resource "aws_security_group" "eric_security_group" {
  name        = "dev_sg"
  description = "dev_security_group"
  vpc_id      = aws_vpc.eric_main_vpc.id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" #any protocol tcp = 6
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dev_secgroup"
  }
}

