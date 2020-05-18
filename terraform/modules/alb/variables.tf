variable "vpc_id" {
  description = "Define variables in main.tf"
}

variable "tags" {
  description = "Define tags in main.tf"
}

variable "suffix" {
  description = "Define suffix in main.tf"
}

variable "subnets" {
  type = list
}

variable "instance_ids" {
  description = "Define the instances id in main.tf"
}

variable "http_sg" {
  description = "Define the alb security group for HTTP in main.tf"
}