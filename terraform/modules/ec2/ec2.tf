//latest amazon linux ami
data aws_ssm_parameter amzn2_ami {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}


resource "aws_key_pair" "ssh-login" {
  key_name = "ssh-login"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "terraform-ec2" {

  count = var.instance_count
  vpc_security_group_ids = var.sg_ids

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

  provisioner "remote-exec" {
    inline = [
      "sudo amazon-linux-extras install java-openjdk11 -y",
    ]
  }
  tags = var.tags
}