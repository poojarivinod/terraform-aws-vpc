data "aws_availability_zones" "available" { # data source availability zone terraform --> Terraform registry
  state = "available"
}


data "aws_vpc" "default" { #data source default vpc terraform --> Terraform registry
  default = true 
}