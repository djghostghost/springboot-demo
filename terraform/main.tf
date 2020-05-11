provider "aws" {
  profile = "default"
  region = "ap-northeast-1"
}

// Create sg of vpc smartnews
resource "aws_security_group" "terraform-mysql-sg" {
  name = format("%s-%s", "tf-mysql-sg", var.suffix)
  description = "security group of mysql"
  vpc_id = "vpc-6b6dda0f"
  tags = {
    Cost = var.cost
    Team = var.team
    System = var.system
    Env = var.env
  }
}

resource "aws_security_group" "terraform-ec2-sg" {
  name = format("%s-%s", "tf-ec2-sg", var.suffix)
  description = "security group of ec2"
  vpc_id = "vpc-6b6dda0f"
  tags = {
    Cost = var.cost
    Team = var.team
    System = var.system
    Env = var.env
  }
}

resource "aws_security_group_rule" "terraform-mysql-sg" {
  type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  source_security_group_id = aws_security_group.terraform-ec2-sg.id
  security_group_id = aws_security_group.terraform-mysql-sg.id


}

resource "aws_db_subnet_group" "mysql_subnet_group" {
  name = format("%s-%s", "db-subnet-group", var.suffix)
  description = "subnet group of mysql"
  subnet_ids = [
    "subnet-7af7850c",
    "subnet-d969d181"]
  tags = {
    Cost = var.cost
    Team = var.team
    System = var.system
    Env = var.env
  }
}

resource "aws_db_instance" "terraform-mysql" {
  identifier = format("%s-%s", "tf-mysql-instance", var.suffix)
  instance_class = "db.t1.micro"
  engine = "mysql"
  engine_version = "8.0.15"
  storage_type = "gp2"
  username = var.mysql-username
  password = var.mysql-password
  backup_retention_period = 1
  vpc_security_group_ids = [
    aws_security_group.terraform-mysql-sg.id]
  db_subnet_group_name = aws_db_subnet_group.mysql_subnet_group.name

  tags = {
    Cost = var.cost
    Team = var.team
    System = var.system
    Env = var.env
  }
}


data aws_ssm_parameter amzn2_ami {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

// use latest amz2 ami to create ec2 instances
resource "aws_instance" "terraform-ec2" {
  count = 2
  security_groups = [
    aws_security_group.terraform-ec2-sg.id]

  ami = data.aws_ssm_parameter.amzn2_ami.value
  instance_type = "t2.micro"
  subnet_id = var.private-subnets[count.index]

  tags = {
    Cost = var.cost
    Team = var.team
    System = var.system
    Env = var.env
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install java-11-openjdk -y",
      "export MYSQL_URL = ${aws_db_instance.terraform-mysql.endpoint}",
      "export USER_NAME = ${var.mysql-username}",
      "export USER_PASSWORD = ${var.mysql-password}"
      ""
    ]
  }
}