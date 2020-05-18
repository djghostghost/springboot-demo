variable "tags" {
  description = "Define tags in main.tf"
}

variable "suffix" {
  description = "Define suffix in main.tf"
}

variable "subnets" {
  description = "Define subnets in main.tf"
}

variable "instance_count" {
  description = "Define instance_count in main.tf"
}

variable "sg_ids" {
  type = list
  description = "Define instance security group ids in main.tf"
}

variable "rds_endpoint" {
  description = "Define Mysql endpoint in main.tf"
}

variable "rds_username" {
  description = "Define Mysql username in main.tf"
}

variable "rds_password" {
  description = "Define Mysql password in main.tf"
}