
# --------------------------------------------------
# 1. Get available Availability Zones
# --------------------------------------------------

data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "zone-type"
    values = ["availability-zone"]
  }
}

# --------------------------------------------------
# 2. Find latest Amazon Linux 2023 AMI
# --------------------------------------------------

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-kernel-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# --------------------------------------------------
# 3. Create VPC
# --------------------------------------------------

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# --------------------------------------------------
# 4. Create Public Subnet
# --------------------------------------------------

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet"
  }
}

# --------------------------------------------------
# 5. Create Internet Gateway
# --------------------------------------------------

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# --------------------------------------------------
# 6. Create Route Table
# --------------------------------------------------

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# --------------------------------------------------
# 7. Associate Route Table with Public Subnet
# --------------------------------------------------

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# --------------------------------------------------
# 8. Create Security Group
# --------------------------------------------------

resource "aws_security_group" "web" {
  name        = "${var.project_name}-sg"
  description = "Security group for Linux web server"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-sg"
  }
}

# Allow HTTP traffic from the internet
resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.web.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"

  description = "Allow public HTTP traffic"
}



# Allow outbound traffic
resource "aws_vpc_security_group_egress_rule" "outbound" {
  security_group_id = aws_security_group.web.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allow outbound IPv4 traffic"
}

# --------------------------------------------------
# 9. Create EC2 Instance
# --------------------------------------------------

resource "aws_instance" "web" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.web.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  user_data = file("${path.module}/user_data.sh")

  # Replace instance when the startup script changes
  user_data_replace_on_change = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name = "${var.project_name}-server"
  }

  # Ensure the internet route exists before EC2 launches
  depends_on = [
    aws_route_table_association.public
  ]
}
