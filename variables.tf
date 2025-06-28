variable "default_region" {
  description = "default AWS region for the VPC and other resources"
  type        = string
}

variable "vpc_cidr" {
  description = "AWS VPC network CIDR"
  type        = string
}

variable "public_subnet_count" {
  description = "Number of public subnet required"
  type        = number
}

variable "private_subnets_count" {
  description = "Number of private subnet required"
  type        = number
}

variable "number_of_public_address" {
  description = "Public Addresses required"
  type        = number
}

variable "number_of_private_address" {
  description = "Private Addresses required"
  type        = number
}

variable "public_subnet_names" {
  description = "Name list for Public subnets"
  type        = list(string)
}

variable "private_subnet_names" {
  description = "Name list for Private subnets"
  type        = list(string)
}

variable "enable_dns_hostnames" {
  description = "(Optional) A boolean flag to enable/disable DNS hostnames in the VPC. Defaults false."
  default     = false
  type        = string
}

variable "default_tags" {
  default = {
    resourcePurpose = "Customnetwork"
    resourceCreator = "terraform"
  }
}