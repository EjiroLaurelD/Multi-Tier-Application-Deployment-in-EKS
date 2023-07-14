resource "aws_db_subnet_group" "cloudgen_sg" {
  name       = "cloudgen_sg"
  subnet_ids = aws_subnet.public_subnets

  tags = {
    Name = "Cloudgen"
  }
}

resource "aws_db_instance" "cloudgen" {
  identifier             = "cloudgen"
  instance_class         = var.instance_class
  allocated_storage      = 5
  engine                 = var.db_engine
  engine_version         = "~>14.1"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.cloudgen.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.cloudgen.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}

resource "aws_db_parameter_group" "cloudgen_pg" {
  name   = "cloudgen_pg"
  family = var.db_pg

  parameter {
    name  = "log_connections"
    value = "1"
  }
}
