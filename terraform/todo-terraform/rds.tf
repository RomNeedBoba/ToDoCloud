data "aws_secretsmanager_secret_version" "db_creds" {
  secret_id = "db-creds"  # Use the secret's name
}

locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.db_creds.secret_string)
}

resource "aws_db_instance" "mysql_db" {
  allocated_storage     = 20
  engine                = "mysql"
  engine_version        = "8.0.35"
  instance_class        = "db.t3.micro"
  db_name               = "todo_app_db"
  username              = local.db_creds["username"]
  password              = local.db_creds["password"]
  publicly_accessible   = true
  parameter_group_name  = "default.mysql8.0"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot   = true
  tags = {
    Name = "TodoAppDB"
  }
}
