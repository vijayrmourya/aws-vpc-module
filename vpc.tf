resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  enable_dns_hostnames = var.enable_dns_hostnames

  tags = var.default_tags
}

resource "aws_subnet" "public_subnets" {
  for_each = local.public_subnet_map

  vpc_id     = aws_vpc.main.id
  cidr_block = each.value

  tags = merge(var.default_tags, {
    Name = each.key
    Type = "public_subnets"
  })
}

resource "aws_subnet" "private_subnets" {
  for_each = local.private_subnet_map

  vpc_id     = aws_vpc.main.id
  cidr_block = each.value

  tags = merge(var.default_tags, {
    Name = each.key
    Type = "private_subnets"
  })
}
