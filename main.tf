terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.55"
    }
  }

  backend "s3" {
    bucket = "alonit-tf-state-practice"
    key    = "tfstate.json"
    region = "eu-north-1"
    # optional: dynamodb_table = "<table-name>"
  }

  required_version = ">= 1.3.0"
}



provider "aws" {
  region  = var.region
  profile = "default"  # change in case you want to work with another AWS account profile
}

resource "aws_volume_attachment" "example" {
  device_name = "/dev/sdh"
  instance_id = aws_instance.netflix_app.id
  volume_id   = aws_ebs_volume.example.id
}

resource "aws_instance" "netflix_app" {
  ami           = var.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.netflix_app_sg.id]
  key_name = aws_key_pair.deployer.key_name

  depends_on = [
    aws_s3_bucket.example
  ]

  tags = {
    Name = "alonit-tf-basics-${var.env}"
    Env = var.env
  }
}

resource "aws_ebs_volume" "example" {
  availability_zone = aws_instance.netflix_app.availability_zone
  size              = 5

  tags = {
    Name = "alonit-netflix-volume"
  }
}

resource "aws_security_group" "netflix_app_sg" {
  name        = "alonit-netflix-app-sg"   # change <your-name> accordingly
  description = "Allow SSH and HTTP traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_key_pair" "deployer" {
  key_name   = "alonit-netflix-key"
  public_key = file("./mykey.pub")
}


resource "aws_s3_bucket" "example" {
  bucket = "alonit-netflix-bucket-123"

  tags = {
    Name        = "alonit-netflix-bucket-123"
  }
}