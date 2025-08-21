resource "aws_vpc_peering_connection" "default" { # aws peering terraform --> terraform registry
  count = var.is_pairing_required ? 1 : 0 #(true = 1 , false = 0) ( 0 means won't create peering, 1 means create peering)
  vpc_id        = aws_vpc.main.id #requester
  peer_vpc_id   = local.default_vpc_id #acceptor
  auto_accept   = true

  tags = merge(
    var.common_tags,
    var.vpc_peering_tags,
    {
         Name = "${local.resource_name}-default"
    }
  )

}


resource "aws_route" "public_peering" { #aws route terraform --> terraform registry
  count = var.is_pairing_required ? 1 : 0 #(true = 1 , false = 0) ( 0 means won't create peering, 1 means create peering)
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = local.default_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id   #aws route terraform --> terraform registry
# as we are using "count" in aws_vpc_peering_connection resource , so we need give [count.index], even though we having single element in list
}

resource "aws_route" "private_peering" { #aws route terraform --> terraform registry
  count = var.is_pairing_required ? 1 : 0 #(true = 1 , false = 0) ( 0 means won't create peering, 1 means create peering)
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = local.default_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id   #aws route terraform --> terraform registry
# as we are using "count" in aws_vpc_peering_connection resource , so we need give [count.index], even though we having single element in list
}

resource "aws_route" "database_peering" { #aws route terraform --> terraform registry
  count = var.is_pairing_required ? 1 : 0 #(true = 1 , false = 0) ( 0 means won't create peering, 1 means create peering)
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = local.default_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id   #aws route terraform --> terraform registry
# as we are using "count" in aws_vpc_peering_connection resource , so we need give [count.index], even though we having single element in list
}

resource "aws_route" "default_peering" { #aws route terraform --> terraform registry
  count = var.is_pairing_required ? 1 : 0 #(true = 1 , false = 0) ( 0 means won't create peering, 1 means create peering)
  route_table_id            = data.aws_route_table.main.route_table_id  # data source default vpc route table terraform --> terraform registry
  destination_cidr_block    = var.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.default[count.index].id   #aws route terraform --> terraform registry
# as we are using "count" in aws_vpc_peering_connection resource , so we need give [count.index], even though we having single element in list
}

