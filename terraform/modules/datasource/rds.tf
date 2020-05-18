resource "aws_db_subnet_group" "mysql_subnet_group" {
  name = format("%s-%s", "db-subnet-group", var.suffix)
  description = "subnet group of mysql"
  subnet_ids = var.private_subnets
  tags = var.tags
}

resource "aws_db_instance" "terraform-mysql" {
  identifier = format("%s-%s", "tf-mysql-instance", var.suffix)
  instance_class = "db.t2.micro"
  engine = "mysql"
  engine_version = "8.0.15"
  storage_type = "gp2"
  allocated_storage = 20
  name = "book_store"
  username = var.mysql_username
  password = var.mysql_password
  backup_retention_period = 1
  vpc_security_group_ids = var.security_group_ids
  db_subnet_group_name = aws_db_subnet_group.mysql_subnet_group.name
  skip_final_snapshot = true

  tags = var.tags
}