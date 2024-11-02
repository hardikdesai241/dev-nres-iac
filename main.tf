# This code is only for DEV environment. This code will create VPC, Subnets,
# Internet Gateway, Route Table, Security Groups, EC2 Instances, Network Load Balancer,
# RDS Instance and all other required resources in AWS.

# Copy of this code is available at the following location: https://github.com/hardikdesai241/dev-nres-iac
# Actual Code starts from line 9=========================

# Provider configuration

provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# --------------------VPC--------------------
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    local.common_tags,
    {
      Name = "dev-nres-vpc"
    }
  )
}

# ---------------Below code is for Listner Subnets----------------
resource "aws_subnet" "subnet_1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_1a_cidr
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    {
      Name = "dev-listnersubnet-az1a"
    }
  )
}

resource "aws_subnet" "subnet_1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_1b_cidr
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    {
      Name = "dev-listnersubnet-az1b"
    }
  )
}

#----------------Above code is for Listner Subnets----------------

# ----------------Below code is for RDS Subnet----------------

resource "aws_subnet" "dev-oraclerds-subnet_1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.dev-oraclerds-subnet_1a_cidr
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = false

  tags = merge(
    local.common_tags,
    {
      Name = "dev-oracledb-aubnet-az1a"
    }
  )
}

resource "aws_subnet" "dev-oraclerds-subnet_1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.dev-oraclerds-subnet_1b_cidr
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = false

  tags = merge(
    local.common_tags,
    {
      Name = "dev-oracledb-subnet-az1b"
    }
  )
}

# ----------------Above code is for RDS Subnet----------------

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "dev-nres-igw"
    }
  )
}

# Route Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "dev-nres-rt"
    }
  )
}

# Route Table Associations
resource "aws_route_table_association" "subnet_1a" {
  subnet_id      = aws_subnet.subnet_1a.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "subnet_1b" {
  subnet_id      = aws_subnet.subnet_1b.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "rds_subnet_1a" {
  subnet_id      = aws_subnet.dev-oraclerds-subnet_1a.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "rds_subnet_1b" {
  subnet_id      = aws_subnet.dev-oraclerds-subnet_1b.id
  route_table_id = aws_route_table.main.id
}

# Security Group for EC2 instances
resource "aws_security_group" "ec2" {
  name        = "dev-nres-ec2-sg"
  description = "Security group for EC2 instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_ip_cidr]
  }

  ingress {
    from_port   = 1521
    to_port     = 1521
    protocol    = "tcp"
    cidr_blocks = [var.admin_ip_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "dev-nres-ec2-sg"
    }
  )
}

# Security Group for RDS instances
resource "aws_security_group" "dev-oraclerds-SG" {
  name        = "dev-nres-db-sg"
  description = "Security group for RDS instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 1521
    to_port     = 1521
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_ip_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "dev-nres-db-sg"
    }
  )
}

# EC2 Instances in subnet 1a
resource "aws_instance" "ec2_1a" {
  count = var.instances_per_subnet

  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.dev-nres-key-pair
  subnet_id              = aws_subnet.subnet_1a.id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  availability_zone      = "${var.region}a"

  tags = merge(
    local.common_tags,
    {
      Name = "dev-ec2-us-east-1a-${count.index + 1}"
    }
  )
}

# EC2 Instances in subnet 1b
resource "aws_instance" "ec2_1b" {
  count = var.instances_per_subnet

  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.dev-nres-key-pair
  subnet_id              = aws_subnet.subnet_1b.id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  availability_zone      = "${var.region}b"

  tags = merge(
    local.common_tags,
    {
      Name = "dev-ec2-us-east-1b-${count.index + 1}"
    }
  )
}

# Target Group
resource "aws_lb_target_group" "main" {
  name        = "dev-nres-listener-group"
  port        = 443
  protocol    = "TCP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    protocol            = "TCP"
    port                = "443"
    interval            = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  stickiness {
    enabled = false
    type    = "source_ip"
  }

  tags = merge(
    local.common_tags,
    {
      Name = "dev-nres-tg"
    }
  )
}

# Target Group Attachments
resource "aws_lb_target_group_attachment" "ec2_1a" {
  count = var.instances_per_subnet

  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.ec2_1a[count.index].id
  port             = 443
}

resource "aws_lb_target_group_attachment" "ec2_1b" {
  count = var.instances_per_subnet

  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.ec2_1b[count.index].id
  port             = 443
}

# Network Load Balancer
resource "aws_lb" "main" {
  name                             = "dev-nres-nlb"
  internal                         = false
  load_balancer_type               = "network"
  subnets                          = [aws_subnet.subnet_1a.id, aws_subnet.subnet_1b.id]
  enable_cross_zone_load_balancing = true

  tags = merge(
    local.common_tags,
    {
      Name = "dev-nres-nlb"
    }
  )
}

# Load Balancer Listener
resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

#=========================Code for RDS Instance starts=========================

resource "aws_db_subnet_group" "dev-oraclerds-subnet" {
  name       = "nres-oracledb-subnet-group"
  subnet_ids = [aws_subnet.dev-oraclerds-subnet_1a.id, aws_subnet.dev-oraclerds-subnet_1b.id]
}

resource "aws_db_instance" "dev-oraclerds" {
  allocated_storage       = 2048
  max_allocated_storage   = 2048
  db_name                 = "ORACLEDB" # Make sure that database name is all CAPS, otherwise RDS will try to recreate RDS instance every time. The name cannot be more than 8 characters  
  storage_type            = "io2"
  engine                  = "oracle-se2"
  engine_version          = "19"
  instance_class          = "db.m5.xlarge"
  license_model           = "bring-your-own-license"
  iops                    = 1024
  storage_encrypted       = true
  identifier              = "dev-nres-oradb"
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.dev-oraclerds-subnet.name
  vpc_security_group_ids  = [aws_security_group.dev-oraclerds-SG.id]
  publicly_accessible     = true
  skip_final_snapshot     = true
  backup_retention_period = 0
  multi_az                = true
  deletion_protection     = false

  tags = merge(
    local.common_tags,
    {
      Name = "dev-nres-oracledb"
    }
  )

}

#=========================Code for RDS Instance ends=========================