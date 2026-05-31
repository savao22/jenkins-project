provider "aws" {
  region = "us-east-1"
}

# 1. יצירת Security Group חדש שפותח פורטים 22 ו-80
resource "aws_security_group" "jenkins_ansible_sg" {
  name        = "jenkins-ansible-sg"
  description = "Allow SSH and HTTP traffic for Jenkins and Ansible deployment"

  # חוק כניסה עבור SSH (אנסיבל)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # מאפשר גישה מכל מקום לטובת ה-Pipeline
  }

  # חוק כניסה עבור דפדפן אינטרנט (ה-Dashboard שלך)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # מאפשר לכולם לגלוש לאתר שלך
  }

  # חוק יציאה (חובה כדי שהשרת יוכל להוריד עדכונים ו-Apache)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. הגדרת המכונה ושיוך ה-Security Group החדש שיצרנו
resource "aws_instance" "terraform_demo" {
  ami               = "ami-0c7217cdde317cfec"
  instance_type     = "t3.micro"
  availability_zone = "us-east-1c"
  
  # שימוש ב-Security Group הדינמי החדש במקום ה-default החסום
  vpc_security_group_ids = [aws_security_group.jenkins_ansible_sg.id]
  
  key_name          = "class2p"

  tags = {
    Name = "TerraformOS"
  }
}

output "instance_ip" {
  value = aws_instance.terraform_demo.public_ip
}
