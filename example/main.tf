provider "aws" {
  region = var.region
}

locals {
  tags = {

    Example    = "test"
    GithubRepo = "terraform-aws-vpc"
    GithubOrg  = "terraform-aws-modules"
  }
}
module "vpc" {
  source                  = "../"
  cidr_range              = "10.0.0.0/16"
  vpc-public-subnet-cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
  vpc-private-subnet-cidr = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zone       = ["ap-south-1a", "ap-south-1b"]
  map_public_ip_on_launch = true
  total-nat-gateway-required = "1"
  tags                    = local.tags
}