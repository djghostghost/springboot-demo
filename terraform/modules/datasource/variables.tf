variable "tags" {
  description = "Define tags in main.tf"
}

variable "suffix" {
  description = "Define suffix in main.tf"
}

variable "private_subnets" {
  type = list
}

variable "mysql_username" {
  default = "book"
}

variable "mysql_password" {
  default = "book_store"
}

variable "security_group_ids" {
  description = "Define MySql Security Groups in main.tf"
}