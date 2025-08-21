data "aws_availability_zones" "available" { # data source availability zone terraform --> Terraform registry
  state = "available"
}


data "aws_vpc" "default" { #data source default vpc terraform --> Terraform registry
  default = true 
}

data "aws_route_table" "main" { # data source default vpc route table terraform --> stack overflow
  vpc_id = local.default_vpc_id 
  filter {
    name = "association.main"
    values = ["true"]
  }
}
#every vpc, one main route table will be created, we will filter it.