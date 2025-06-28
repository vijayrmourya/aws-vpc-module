locals {
  vpc_mask = tonumber(regex("^.+/(\\d+)$", var.vpc_cidr)[0])

  pub_ips_per_subnet  = ceil(var.number_of_public_address / var.public_subnet_count)
  priv_ips_per_subnet = ceil(var.number_of_private_address / var.private_subnets_count)

  host_bits_public  = ceil(log(local.pub_ips_per_subnet, 2))
  host_bits_private = ceil(log(local.priv_ips_per_subnet, 2))

  new_pubsub_bits  = (32 - local.host_bits_public) - local.vpc_mask
  new_privsub_bits = (32 - local.host_bits_private) - local.vpc_mask

  bit_args = concat(
    [for _ in range(var.public_subnet_count) : local.new_pubsub_bits],
    [for _ in range(var.private_subnets_count) : local.new_privsub_bits]
  )

  allcidrs = cidrsubnets(var.vpc_cidr, local.bit_args...)

  public_sub_cidrs  = slice(local.allcidrs, 0, var.public_subnet_count)
  private_sub_cidrs = slice(local.allcidrs, var.public_subnet_count, var.public_subnet_count + var.private_subnets_count)

  public_subnet_map  = zipmap(var.public_subnet_names, local.public_sub_cidrs)
  private_subnet_map = zipmap(var.private_subnet_names, local.private_sub_cidrs)

  total_vpc_ips         = pow(2, 32 - local.vpc_mask)
  total_request_net_sze = var.number_of_private_address + var.number_of_public_address
  unused_vpc_size       = local.total_vpc_ips - local.total_request_net_sze
}
