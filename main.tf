terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 4.0"
        }
    }
}


# Configure the AWS Provider
provider "aws" {
    region     = var.region
    profile    = "default"
}

# Create a VPC
resource "aws_vpc" "myvpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support   = true
}


resource "aws_internet_gateway" "_" {
  vpc_id = aws_vpc.myvpc.id
}


resource "aws_subnet" "ap-northeast-1a" {
    vpc_id            = aws_vpc.myvpc.id
    map_public_ip_on_launch = true
    availability_zone = "ap-northeast-1a"
    cidr_block        = "10.0.1.0/24"

    tags = {
        AZ = "1a"
    }
}


resource "aws_subnet" "ap-northeast-1c" {
    vpc_id            = aws_vpc.myvpc.id
    map_public_ip_on_launch = true
    availability_zone = "ap-northeast-1c"
    cidr_block        = "10.0.2.0/24"

    tags = {
        AZ = "1c"
    }
}


resource "aws_subnet" "ap-northeast-1d" {
    vpc_id            = aws_vpc.myvpc.id
    map_public_ip_on_launch = true
    availability_zone = "ap-northeast-1d"
    cidr_block        = "10.0.3.0/24"

    tags = {
        AZ = "1d"
    }
}


resource "aws_db_subnet_group" "subnetGroup" {
    name       = "main"

    subnet_ids = [
        aws_subnet.ap-northeast-1a.id,
        aws_subnet.ap-northeast-1c.id,
        aws_subnet.ap-northeast-1d.id
    ]

    tags = {
        Stage = var.stage
        Name = "My DB subnet group"
    }
}


resource "aws_security_group" "rds" {
    name        = "imbee_rds_security_group"
    description = "RDS MySQL server"
    vpc_id      = "${aws_vpc.myvpc.id}"
    # Keep the instance private by only allowing traffic from the web server.
    ingress {
        from_port       = 3306
        to_port         = 3306
        protocol        = "tcp"
    }
    # Allow all outbound traffic.
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Stage = var.stage
        Name = "rds_security"
    }
}


resource "aws_db_parameter_group" "imbee_group" {
  name   = "imbee-notification-group"
  family = "mysql5.7"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_db_instance" "imbee_db" {
    allocated_storage    = 10
    max_allocated_storage = 20
    db_name              = var.db_name
    engine               = "mysql"
    engine_version       = "5.7.40"
    instance_class       = "db.t3.micro"
    username             = var.db_username
    password             = var.db_password

    # when use replica that have to set a backup
    backup_retention_period   = 1
    # for hw test
    publicly_accessible  = true
    vpc_security_group_ids    = ["${aws_security_group.rds.id}"]

    skip_final_snapshot  = true
    parameter_group_name = aws_db_parameter_group.imbee_group.name
    db_subnet_group_name = aws_db_subnet_group.subnetGroup.name
}


# set replica for HA (High Availability)
resource "aws_db_instance" "imbee_db_replica" {
   identifier             = "imbee-db-replica"
   replicate_source_db    = aws_db_instance.imbee_db.identifier
   instance_class         = "db.t3.micro"
   apply_immediately      = true
   publicly_accessible    = true
   skip_final_snapshot    = true
   vpc_security_group_ids    = ["${aws_security_group.rds.id}"]
   parameter_group_name   = aws_db_parameter_group.imbee_group.name
}


resource "aws_ecr_repository" "repo_imbee" {
    name                 = var.project_name
    image_tag_mutability = "MUTABLE"

    image_scanning_configuration {
        scan_on_push = true
    }
}
