provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "terraform_demo" {
  ami                    = "ami-0c7217cdde317cfec"
  instance_type          = "t3.micro"
  availability_zone      = "us-east-1c"
  vpc_security_group_ids = ["sg-00ef03cc35ddaa39c"]
  key_name               = "class2p"

  tags = {
    Name = "TerraformOS"
  }
}

output "instance_ip" {
  value = aws_instance.terraform_demo.public_ip
}
