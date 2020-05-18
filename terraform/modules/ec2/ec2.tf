data aws_ssm_parameter amzn2_ami {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}


resource "aws_key_pair" "ssh-login" {
  key_name = "ssh-login"
  public_key = file("~/.ssh/id_rsa.pub")
}

// use latest amz2 ami to create ec2 instances
resource "aws_instance" "terraform-ec2" {

  count = var.instance_count

  security_groups = var.sg_ids

  ami = data.aws_ssm_parameter.amzn2_ami.value
  instance_type = "t2.micro"
  subnet_id = var.subnets[count.index]


  key_name = aws_key_pair.ssh-login.key_name
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
    host = self.public_ip
  }
  provisioner "file" {
    source = "./springboot-demo-0.0.1-SNAPSHOT.jar"
    destination = "/home/ec2-user/demo.jar"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install java-openjdk11 -y",
      "export MYSQL_ENDPOINT=${var.rds_endpoint}",
      "export MYSQL_USERNAME=${var.rds_username}",
      "export MYSQL_PASSWORD=${var.rds_password}",
      "echo $MYSQL_ENDPOINT>endpoint.txt",
      "cd /home/ec2-user &&nohup java -jar demo.jar>logs.txt&"
    ]
  }
  tags = var.tags
}