#### Create MySQL Security Group ####
resource "aws_security_group" "terraform-mysql-sg" {
  name = format("%s-%s", "tf-mysql-sg", var.suffix)
  description = "security group of mysql"
  vpc_id = "vpc-6b6dda0f"

  ingress {

    from_port = 3306
    protocol = "tcp"
    to_port = 3306
    security_groups = [
      aws_security_group.terraform-ec2-app-sg.id]
  }

  tags = var.tags
}

#### Create EC2 Security Group for WebService ####
resource "aws_security_group" "terraform-ec2-app-sg" {
  name = format("%s-%s", "tf-ec2-sg", var.suffix)
  description = "security group of ec2"
  vpc_id = "vpc-6b6dda0f"
  ingress {
    from_port = 8080
    protocol = "tcp"
    to_port = 8080
    security_groups = [
      aws_security_group.alb.id]
    description = "for alb"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags = var.tags
}


#### Create EC2 Security Group for SSH ####
resource "aws_security_group" "terraform-ec2-sg-ssh" {
  name = format("%s-%s", "tf-ec2-ssh-sg", var.suffix)
  description = "subnet group of mysql"
  vpc_id = "vpc-6b6dda0f"

  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = [
      "0.0.0.0/0"]
    description = "all"
  }

  tags = var.tags
}

#### Create ALB Security Group for port 80 ####
resource "aws_security_group" "alb" {
  name = "terraform-handson-sg"
  vpc_id = var.vpc_id
  description = "security group for alb"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags = var.tags
}