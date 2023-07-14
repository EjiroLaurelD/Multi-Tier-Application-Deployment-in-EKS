resource "aws_vpc" "main" {
  cidr_block            = var.vpc_block.cidr_block
  enable_dns_hostnames  = true
  tags = {
    Name                = var.vpc_block.name
  }
}

resource "aws_subnet" "subnets" {
  for_each              = var.subnet_blocks

  vpc_id                = aws_vpc.main.id
  cidr_block            = each.value["cidr"]
  availability_zone     = each.value["az"]

  tags = {
    Name                = each.key
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id                = aws_vpc.main.id

  tags = {
    Name                = var.igw
  }
}

resource "aws_route_table" "main" {
  vpc_id                = aws_vpc.main.id

  route {
    cidr_block          = var.rtb.cidr_block
    gateway_id          = aws_internet_gateway.main.id
  }

  tags = {
    Name        = var.rtb.name
  }
}

resource "aws_route_table_association" "main" {
  for_each              = aws_subnet.subnets

  subnet_id             = each.value.id
  route_table_id        = aws_route_table.main.id
}

resource "aws_security_group" "alb_sg" {
  name                  = var.sg[0]
  description           = "Allow HTTPS and HTTP inbound traffic for application load balancer"
  vpc_id                = aws_vpc.main.id

  dynamic "ingress" {
    for_each            = var.inbound_ports

    content {
      from_port                 = ingress.value
      to_port           = ingress.value
      protocol          = "tcp"
      cidr_blocks       = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "instance_sg" {
  name                  = var.sg[1]
  description           = "Allow HTTPS and HTTP inbound traffic for the instances"
  vpc_id                = aws_vpc.main.id

  dynamic "ingress" {
    for_each            = var.inbound_ports

    content {
      from_port                 = ingress.value
      to_port           = ingress.value
      protocol          = "tcp"
      security_groups     = [aws_security_group.alb_sg.id]
    }
  }

  ingress {
    description         = "Allow SSH"
    from_port           = 22
    to_port             = 22
    protocol            = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

