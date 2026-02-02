# -----------------------------------------------------------------------------
# Custom EC2 module - creates one EC2 instance in default VPC with a security group
# -----------------------------------------------------------------------------

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_security_group" "instance" {
  name        = "${var.name_prefix}-sg"
  description = "Security group for custom EC2 module instance"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
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

  tags = {
    Name        = "${var.name_prefix}-sg"
    Environment = var.environment
  }
}

resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids  = [aws_security_group.instance.id]
  subnet_id              = tolist(data.aws_subnets.default.ids)[0]
  associate_public_ip_address = true

  tags = {
    Name        = var.name_prefix
    Environment = var.environment
  }
}
