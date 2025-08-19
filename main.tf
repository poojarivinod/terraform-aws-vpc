resource "aws_vpc" "main" { #terraform aws vpc resource-->Terraform registry
  cidr_block       = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  instance_tenancy = "default"

  # expense-dev
  tags = merge(
    var.common_tags,
    var.vpc_tags,
    {
        Name = local.resource_name
    }

  )
}

resource "aws_internet_gateway" "main" { #terraform aws internet gateway--> Terraform registry
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.ig_tags,
    {
         Name = local.resource_name
    }
  )
}
 
# expense-dev-public-us-east-1a
resource "aws_subnet" "public" { # aws subnet terraform --> terraform registry
  count = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = true
  tags = merge(
    var.common_tags,
    var.public_subnet_tags,
    {
         Name = "${local.resource_name}-public-${local.az_names[count.index]}"
    }
  )
}

# expense-dev-private-us-east-1a
resource "aws_subnet" "private" { # aws subnet terraform --> terraform registry
  count = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]
  
  tags = merge(
    var.common_tags,
    var.private_subnet_tags,
    {
         Name = "${local.resource_name}-private-${local.az_names[count.index]}"
    }
  )
}

# expense-dev-database-us-east-1a
resource "aws_subnet" "database" { # aws subnet terraform --> terraform registry
  count = length(var.database_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]
  
  tags = merge(
    var.common_tags,
    var.database_subnet_tags,
    {
         Name = "${local.resource_name}-database-${local.az_names[count.index]}"
    }
  )
}

resource "aws_eip" "nat" { # aws elastic ip terraform --> terraform registry
  domain   = "vpc"
}

resource "aws_nat_gateway" "example" { # aws nat gateway terraform --> terraform registry
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags =  merge(
    var.common_tags,
    var.nat_gateway_tags,
    {
         Name = local.resource_name
    }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main] # terraform make sure internet gateway is already exist, then it will create nat gateway
}

resource "aws_route_table" "public" { #aws route table terraform --> terraform registry
  vpc_id = aws_vpc.main.id

    tags = merge(
    var.common_tags,
    var.public_route_table_tags,
    {
         Name = "${local.resource_name}-public"
    }
  )
}

resource "aws_route_table" "private" { #aws route table terraform --> terraform registry
  vpc_id = aws_vpc.main.id

    tags = merge(
    var.common_tags,
    var.private_route_table_tags,
    {
         Name = "${local.resource_name}-private"
    }
  )
}

resource "aws_route_table" "database" { #aws route table terraform --> terraform registry
  vpc_id = aws_vpc.main.id

    tags = merge(
    var.common_tags,
    var.database_route_table_tags,
    {
         Name = "${local.resource_name}-database"
    }
  )
}

resource "aws_route" "public" { #aws route terraform --> terraform registry
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}


resource "aws_route" "private" { #aws route terraform --> terraform registry
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.example.id
}


resource "aws_route" "database" { #aws route terraform --> terraform registry
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.example.id
}

resource "aws_route_table_association" "public" { #aws route table association terraform -->  terraform registry
  count = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" { #aws route table association terraform -->  terraform registry
  count = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" { #aws route table association terraform -->  terraform registry
  count = length(var.database_subnet_cidrs)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}