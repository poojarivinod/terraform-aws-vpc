# output "azs_info" {
#   value       = data.aws_availability_zones.available
# }

# output "subnets_info" {
#     value =  aws_subnet.public
# }

output "vpc_id" {
    value = aws_vpc.main.id
}

output "public_subnet_ids" {
    value = aws_subnet.public[*].id # "*"  means all public id in subnets
}

output "private_subnet_ids" {
    value = aws_subnet.private[*].id # "*"  means all public id in subnets
}

output "database_subnet_ids" {
    value = aws_subnet.database[*].id # "*"  means all public id in subnets
}