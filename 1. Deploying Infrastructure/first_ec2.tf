provider "aws" {
  region     = "us-east-1"
  access_key = "YOUR-ACCESS-KEY"
  secret_key = "YOUR-SECRET-KEY"
}

# aws_instance resource type is required, but the name "test-ec2" can be changed to any valid identifier
# Each ec2 has a unique AMI ID which differs from one region to another, which is used to identify the ec2 instance.
resource "aws_instance" "test-ec2" {
    ami = "ami-00c39f71452c08778"
    instance_type = "t2.micro"
    tags = {
        Name = "test-ec2"
    }
}