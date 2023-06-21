# Define the provider
provider "aws" {
  region  = "us-east-1"
  profile = "myaws"
}


# Create a VPC
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/20"

  tags = {
    Name = "Example VPC"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id

  tags = {
    Name = "Example IGW"
  }
}

# Create a subnet
resource "aws_subnet" "example_subnet" {
  vpc_id     = aws_vpc.example_vpc.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "Example Subnet"
  }
}

# Create a route table
resource "aws_route_table" "example_route_table" {
  vpc_id = aws_vpc.example_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example_igw.id
  }

  tags = {
    Name = "Example Route Table"
  }
}

# Associate the subnet with the route table
resource "aws_route_table_association" "example_route_table_association" {
  subnet_id      = aws_subnet.example_subnet.id
  route_table_id = aws_route_table.example_route_table.id
}

# Create a security group
resource "aws_security_group" "example_sg" {
  name        = "Example Security Group"
  description = "Allow SSH access"

  vpc_id = aws_vpc.example_vpc.id

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

# Launch an EC2 instance
resource "aws_instance" "example_instance" {
  ami           = "ami-022e1a32d3f742bd8"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.example_sg.id]
  subnet_id              = aws_subnet.example_subnet.id

  key_name = "N.Virginia"

  associate_public_ip_address = true

  tags = {
    Name = "Example Instance"
  }
}


