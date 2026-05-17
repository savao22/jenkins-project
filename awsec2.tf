resource "aws_instance" "terraform_demo" {
  ami                    = "ami-0533af068c146e115"
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
