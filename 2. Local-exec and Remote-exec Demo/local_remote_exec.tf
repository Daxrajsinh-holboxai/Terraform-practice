# -----------------------------------------------------------------------------
# Local-exec and Remote-exec Demo
# - remote-exec: runs a basic task on the EC2 instance (writes "Working" to a file)
# - local-exec: stores the EC2 public IP address in a .txt file on your machine
#
# Variables are declared in variables.tf; set values in terraform.tfvars
# (copy from terraform.tfvars.example).
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Provider
# -----------------------------------------------------------------------------

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# -----------------------------------------------------------------------------
# Data: Default VPC and subnet (for public IP / SSH)
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

# -----------------------------------------------------------------------------
# Key pair for SSH (remote-exec)
# -----------------------------------------------------------------------------

resource "tls_private_key" "demo" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "private_key" {
  content         = tls_private_key.demo.private_key_pem
  filename        = "${path.module}/demo_key.pem"
  file_permission = "0600"
}

resource "aws_key_pair" "demo" {
  key_name   = "local-remote-exec-demo-key"
  public_key = tls_private_key.demo.public_key_openssh
}

# -----------------------------------------------------------------------------
# Security group: allow SSH (port 22)
# -----------------------------------------------------------------------------

resource "aws_security_group" "demo" {
  name        = "local-remote-exec-demo-sg"
  description = "Allow SSH for provisioner demo"
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
    Name        = "local-remote-exec-demo-sg"
    Environment = var.environment
  }
}

# -----------------------------------------------------------------------------
# EC2 instance with provisioners
# -----------------------------------------------------------------------------

resource "aws_instance" "demo" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.demo.key_name
  vpc_security_group_ids = [aws_security_group.demo.id]
  subnet_id              = tolist(data.aws_subnets.default.ids)[0]
  associate_public_ip_address = true

  tags = {
    Name        = "local-remote-exec-demo"
    Environment = var.environment
  }

  # ---------------------------------------------------------------------------
  # Local-exec: run on your machine after instance is created
  # Stores the EC2 public IP in ec2_ip.txt
  # ---------------------------------------------------------------------------
  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ${path.module}/ec2_ip.txt"
  }

  # ---------------------------------------------------------------------------
  # Remote-exec: run on the EC2 instance via SSH
  # Performs a basic task: write "Working" to a file on the instance
  # ---------------------------------------------------------------------------
  provisioner "remote-exec" {
    inline = [
      "sleep 15",
      "echo 'Working' > /tmp/remote_exec_demo.txt",
      "cat /tmp/remote_exec_demo.txt"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = tls_private_key.demo.private_key_pem
      host        = self.public_ip
      timeout     = "60s"
    }
  }
}

# -----------------------------------------------------------------------------
# Outputs
# -----------------------------------------------------------------------------

output "instance_public_ip" {
  description = "Public IP of the demo EC2 instance"
  value       = aws_instance.demo.public_ip
}

output "ec2_ip_file" {
  description = "Path to the local file where the IP was stored (local-exec)"
  value       = "${path.module}/ec2_ip.txt"
}

output "remote_task_file" {
  description = "Path on EC2 where remote-exec wrote the result"
  value       = "/tmp/remote_exec_demo.txt"
}
