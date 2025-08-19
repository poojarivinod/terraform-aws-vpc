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