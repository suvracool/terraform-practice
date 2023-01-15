/*
This example show association of one resource to other using attributes.
1) In first example we are creating EC2 instance and an Elastic IP.
After that we are attaching the EIP with the EC2 instance using aws_eip_association resource and using
attributes from both ec2 instance and elastic ip

2) In 2nd example we are allowing inbound traffic of the security group to enter to the elastic IP through port 443.
*/

provider "aws" {
  region     = "us-west-2"
  access_key = var.access_key
  secret_key = var.secret_key
}



resource "aws_instance" "myec2" {
   ami = "ami-082b5a644766e0e6f"
   instance_type = "t2.micro"
}

resource "aws_eip" "lb" {
  vpc      = true
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.myec2.id
  allocation_id = aws_eip.lb.id
}


resource "aws_security_group" "allow_tls" {
  name        = "suv-security-group"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${aws_eip.lb.public_ip}/32"]

#    cidr_blocks = [aws_eip.lb.public_ip/32]
  }
}

output "eip" {
  value = aws_eip.lb.public_ip
}

output "aws_eip_association" {
  value = aws_eip_association.eip_assoc.public_ip
}

output "aws_security_group" {
  value = aws_security_group.allow_tls.id
}
