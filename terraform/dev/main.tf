provider "aws" {
  profile = "default"
  region = "ap-northeast-1"
}

module "sg" {
  source = "../modules/sg"
  suffix = var.suffix
  tags = var.resource_tags
  vpc_id = var.vpc_id
}

module "mysql" {
  source = "../modules/datasource"
  private_subnets = var.private_subnets
  security_group_ids = [
    module.sg.mysql_sg_id]
  suffix = var.suffix
  tags = var.resource_tags
}

module "ec2" {
  source = "../modules/ec2"
  instance_count = var.instance_count
  rds_endpoint = module.mysql.mysql_endpoint
  rds_password = module.mysql.mysql_username
  rds_username = module.mysql.mysql_password
  sg_ids = [
    module.sg.ec2_service_sg_id,
    module.sg.ec_ssh_sg_id]
  subnets = var.public_subnets
  suffix = var.suffix
  tags = var.resource_tags
}

module "alb" {
  source = "../modules/alb"
  instance_ids = module.ec2.ec2_instance_ids
  subnets = var.public_subnets
  suffix = var.suffix
  tags = var.resource_tags
  vpc_id = var.vpc_id
  http_sg = module.sg.alb_http_sg_id
}
