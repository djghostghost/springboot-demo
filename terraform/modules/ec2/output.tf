output "ec2_instance_ids" {
  value = aws_instance.terraform-ec2.*.id
}