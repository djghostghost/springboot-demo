
variable "team" {
  default = "Growth-Backend"
  description = "The team name"
}

variable "system" {
  default = "Terraform-handson"
  description = "The System's name"
}

variable "env" {
  default = "dev"
  description = "The enviroment name like dev or prd"
}

variable "cost" {
  default = "smartnews"
}

variable "suffix" {
  default = "garrus"
}

variable "mysql-username" {
  default = "book"
}

variable "mysql-password" {
  default = "book_store"
}

variable "private-subnets" {
  description = "private subnets"
  default = ["subnet-7af7850c","subnet-d969d181"]
}

variable "jar-download-url" {
  default = ""
}