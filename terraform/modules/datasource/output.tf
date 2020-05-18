output "mysql_endpoint" {
  value = "${aws_db_instance.terraform-mysql.endpoint}/${aws_db_instance.terraform-mysql.name}"
}

output "mysql_username" {
  value = var.mysql_username
}

output "mysql_password" {
  value = var.mysql_password
}