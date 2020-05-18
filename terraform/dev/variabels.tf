variable "suffix" {
  default = "garrus"
}

variable "vpc_id" {
  default = "vpc-6b6dda0f"
}

variable "private_subnets" {
  description = "private subnets"
  default = [
    "subnet-7af7850c",
    "subnet-d969d181"]
}

variable "public_subnets" {
  description = "public subnets"
  default = [
    "subnet-7df7850b",
    "subnet-da69d182"]
}

variable "resource_tags" {
  type = map
  default = {
    Cost = "smartnews"
    Team = "Growth-Backend"
    System = "Terraform-Handson"
    Env = "dev"
  }
}

variable "instance_count" {
  default = 2
}