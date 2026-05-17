provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "terraform_demo" {
  ami                    = "ami-0c7217cdde317cfec"
  instance_type          = "t3.micro"
  availability_zone      = "us-east-1c"
  
  # תיקון: שימוש ב-Security Group המובנה של ה-VPC במקום מזהה קשיח
  security_groups        = ["default"]
  
  key_name               = "class2p"

  tags = {
    Name = "TerraformOS"
  }
}

output "instance_ip" {
  value = aws_instance.terraform_demo.public_ip
}
