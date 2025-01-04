resource "aws_security_group" "rds_sg" {
  name        = "RdsSecurityGroup"
  description = "Allow inbound traffic on MySQL (3306)"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with EC2 IP or VPC CIDR
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RdsSecurityGroup"
  }
}
