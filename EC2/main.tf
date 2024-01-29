resource "aws_vpc" "tijko_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "tijko_public_subnet" {
  vpc_id                  = aws_vpc.tijko_vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-2a"

  tags = {
    Name = "dev-public"
  }
}

resource "aws_internet_gateway" "tijko_internet_gateway" {
  vpc_id = aws_vpc.tijko_vpc.id

  tags = {
    Name = "tijko_igw"
  }
}

resource "aws_route_table" "tijko_public_rt" {
  vpc_id = aws_vpc.tijko_vpc.id

  tags = {
    Name = "dev_public_rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.tijko_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.tijko_internet_gateway.id
}

resource "aws_route_table_association" "tijko_public_assoc" {
  subnet_id      = aws_subnet.tijko_public_subnet.id
  route_table_id = aws_route_table.tijko_public_rt.id
}

resource "aws_security_group" "tijko_sg" {
  name        = "public_sg"
  description = "public security group"
  vpc_id      = aws_vpc.tijko_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_key_pair" "tijko_auth" {
  key_name   = "tijko"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "dev_node" {
  instance_type = "t2.micro"
  ami           = data.aws_ami.server_ami.id

  tags = {
    Name = "dev_node"
  }

  key_name               = aws_key_pair.tijko_auth.id
  vpc_security_group_ids = [aws_security_group.tijko_sg.id]
  subnet_id              = aws_subnet.tijko_public_subnet.id

  root_block_device {
    volume_size = 8
  }
}