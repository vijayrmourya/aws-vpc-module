output "calculated_subnets" {
  value = {
    PublicSubnets  = local.public_subnet_map,
    PrivateSubnets = local.private_subnet_map
  }
}

output "used_vpc_network_address_count" {
  value = local.total_request_net_sze
}

output "unused_vpc_network_address_count" {
  value = local.unused_vpc_size
}