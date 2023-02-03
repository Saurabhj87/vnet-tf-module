
variable "cidr_range" {
  description = "cidr range for vpc"
  type        = string
  default     = "10.0.0.0/16"
}
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
variable "enable_dns_support" {
  type    = bool
  default = true
}
variable "enable_dns_hostnames" {
  type    = bool
  default = true
}
variable "instance_tenancy" {
  type    = string
  default = "default"
}
variable "vpc-public-subnet-cidr" {
  type = list(string)

}
variable "availability_zone" {
  type = list(string)

}
variable "map_public_ip_on_launch" {
  type    = bool
  default = "true"
}
variable "vpc-private-subnet-cidr" {
  type = list(string)

}
variable "enabled" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  type        = bool
  default     = true
}
variable "total-nat-gateway-required" {
  type = string
}

# Private Route Cidr
variable "private-route-cidr" {
  default = "0.0.0.0/0"
}