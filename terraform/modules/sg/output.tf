output "mysql_sg_id" {
  value = aws_security_group.terraform-mysql-sg.id
}

output "ec2_service_sg_id" {
  value = aws_security_group.terraform-ec2-app-sg.id
}

output "ec_ssh_sg_id" {
  value = aws_security_group.terraform-ec2-sg-ssh.id
}

output "alb_http_sg_id" {
  value = aws_security_group.alb.id
}