provider "aws" {
  region = "us-west-2"  # Make sure this matches your AWS region
}

# Security Group: Allow SSH and HTTP access
resource "aws_security_group" "ec2_sg" {
  name_prefix = "ec2_sg"
  description = "Allow SSH and HTTP access"

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

# EC2 Instance
resource "aws_instance" "app_instance" {
  ami           = "ami-0044a0897b53acfb6"  # Use one of the new AMI IDs
  instance_type = "t2.micro"
  key_name      = "cloudRom"  # Replace with your key pair name
  subnet_id     = "subnet-077ffd6f9a51e58c8"  # Replace with the correct subnet ID
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]  # Use created security group ID

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    # Install Docker
    sudo yum install -y docker
    sudo service docker start
    sudo chkconfig docker on
    sudo usermod -aG docker ec2-user
    # Install Git
    sudo yum install -y git
    # Install AWS CLI
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
  EOF

  tags = {
    Name = "TodoAppInstance"
  }
}

# Output the public IP of the instance
output "instance_public_ip" {
  value = aws_instance.app_instance.public_ip
}

