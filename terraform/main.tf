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
  ingress {
    from_port = 8080
    protocol = "tcp"
    to_port = 8080
    cidr_blocks = ["0.0.0.0/0"]
    description = "all"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Cost = var.cost
    Team = var.team
    System = var.system
    Env = var.env
  }
}

resource "aws_security_group_rule" "terraform-mysql-sg-rule" {
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
  subnet_ids = var.private-subnets
  tags = {
    Cost = var.cost
    Team = var.team
    System = var.system
    Env = var.env
  }
}

resource "aws_db_instance" "terraform-mysql" {
  identifier = format("%s-%s", "tf-mysql-instance", var.suffix)
  instance_class = "db.t2.micro"
  engine = "mysql"
  engine_version = "8.0.15"
  storage_type = "gp2"
  allocated_storage = 20
  name = "book_store"
  username = var.mysql-username
  password = var.mysql-password
  backup_retention_period = 1
  vpc_security_group_ids = [
    aws_security_group.terraform-mysql-sg.id]
  db_subnet_group_name = aws_db_subnet_group.mysql_subnet_group.name
  skip_final_snapshot = true

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


resource "aws_key_pair" "ssh-login" {
  key_name = "ssh-login"
  public_key = file("~/.ssh/id_rsa.pub")
}

// use latest amz2 ami to create ec2 instances
resource "aws_instance" "terraform-ec2" {

  count = 2

  security_groups = [
    aws_security_group.terraform-ec2-sg.id,
  aws_security_group.terraform-ec2-sg-ssh.id]

  ami = data.aws_ssm_parameter.amzn2_ami.value
  instance_type = "t2.micro"
  subnet_id = var.public-subnets[count.index]

  tags = {
    Cost = var.cost
    Team = var.team
    System = var.system
    Env = var.env
    Name = format("Terraform_EC2_%s_%s", var.suffix, count.index)
  }

  key_name = aws_key_pair.ssh-login.key_name
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
    host = self.public_ip
  }

  provisioner "file" {
    source = "../build/libs/springboot-demo-0.0.1-SNAPSHOT.jar"
    destination = "/home/ec2-user/demo.jar"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install java-openjdk11 -y",
      "export MYSQL_ENDPOINT=${aws_db_instance.terraform-mysql.endpoint}/${aws_db_instance.terraform-mysql.name}",
      "export MYSQL_USERNAME=${var.mysql-username}",
      "export MYSQL_PASSWORD=${var.mysql-password}",
      "echo $MYSQL_ENDPOINT>/home/ec2-user/mysql.txt",
      "cd /home/ec2-user && java -jar demo.jar&"
    ]
  }
}

resource "aws_security_group" "terraform-ec2-sg-ssh"{
  name = format("%s-%s", "tf-ec2-ssh-sg", var.suffix)
  description = "subnet group of mysql"
  vpc_id = "vpc-6b6dda0f"

  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
    description = "all"
  }

  tags = {
    Cost = var.cost
    Team = var.team
    System = var.system
    Env = var.env
  }
}

