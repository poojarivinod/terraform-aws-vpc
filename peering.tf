resource "aws_vpc_peering_connection" "foo" { # aws peering terraform --> terraform registry
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