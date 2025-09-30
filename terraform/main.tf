data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

}
resource "aws_key_pair" "web_app_key" {
  public_key = file("../web-app-key.pem.pub")
  key_name   = var.key_name

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.project_name}-vpc"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-igw"
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  count                   = length(var.public_subnet_cidrs)
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name       = "${var.project_name}-public-subnet-${count.index + 1}"
    Envronment = var.environment
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "${var.project_name}-public-rt"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[count.index].id
  count          = length(aws_subnet.public)
}

resource "aws_security_group" "webapp" {
  name        = "${var.project_name}-webapp-sg"
  description = "Security group for the webapp"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-webapp-sg"
    Environment = var.environment
  }
}

resource "aws_eip" "webapp" {
  domain = "vpc"

  tags = {
    Name        = "${var.project_name}-eip"
    Environment = var.environment
  }
}

resource "aws_instance" "webapp" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.webapp.id]
  key_name               = aws_key_pair.web_app_key.key_name
  subnet_id              = aws_subnet.public[0].id

  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true

    tags = {
      Environment = var.environment
      Project     = var.project_name
      Name        = "${var.project_name}-ebs"
    }
  }

  user_data                   = filebase64("user-data.sh")
  associate_public_ip_address = true

  tags = {
    Name        = "${var.project_name}-ec2"
    Environment = var.environment
    Project     = var.project_name
  }

  depends_on = [aws_internet_gateway.main]
}

resource "aws_eip_association" "webapp" {
  instance_id   = aws_instance.webapp.id
  allocation_id = aws_eip.webapp.id
}
