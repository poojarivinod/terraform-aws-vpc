variable "project_name" {

}

variable "environment" {

}

variable "vpc_cidr" {
    
}

variable "enable_dns_hostnames" {
    default = true
}

#mandatory
variable "common_tags" {
    type = map
    #default = {}
}

variable "vpc_tags" {
    default = {}
}

variable "ig_tags" {
    default = {}
}

variable "public_subnet_tags" {
    default = {}
}

variable "public_subnet_cidrs" {
    type = list
    validation { # terraform variable size condition --> input variables
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "please provide 2 valid public subnet CIDR"
  }
}

variable "private_subnet_tags" {
    default = {}
}

variable "private_subnet_cidrs" {
    type = list
    validation { # terraform variable size condition --> input variables
    condition     = length(var.private_subnet_cidrs) == 2
    error_message = "please provide 2 valid private subnet CIDR"
  }
}

variable "database_subnet_tags" {
    default = {}
}

variable "database_subnet_cidrs" {
    type = list
    validation { # terraform variable size condition --> input variables
    condition     = length(var.database_subnet_cidrs) == 2
    error_message = "please provide 2 valid database subnet CIDR"
  }
}

variable "nat_gateway_tags" {
    default = {}
}

variable "public_route_table_tags" {
    default = {}
}


variable "private_route_table_tags" {
    default = {}
}


variable "database_route_table_tags" {
    default = {}
}

variable "is_pairing_required" {
    default = false
}

variable "vpc_peering_tags" {
    default = {}
}