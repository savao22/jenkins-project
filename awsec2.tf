provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "jenkins_ansible_sg" {
  name        = "jenkins-ansible-sg"
  description = "Allow SSH and HTTP traffic for Jenkins and Ansible deployment"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "terraform_demo" {
  ami               = "ami-0c7217cdde317cfec"
  instance_type     = "t3.micro"
  availability_zone = "us-east-1c"
  
  vpc_security_group_ids = [aws_security_group.jenkins_ansible_sg.id]
  
  key_name          = "class2p"

  tags = {
    Name = "TerraformOS"
  }
}

output "instance_ip" {
  value = aws_instance.terraform_demo.public_ip
}
