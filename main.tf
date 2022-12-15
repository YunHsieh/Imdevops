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
  family = "mysql8.0"

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
    identifier           = var.db_name
    engine               = "mysql"
    engine_version       = "8.0.28"
    instance_class       = "db.t3.micro"
    username             = var.db_username
    password             = var.db_password

    # when use replica that have to set a backup
    backup_retention_period   = 1
    # for hw test
    publicly_accessible       = true
    vpc_security_group_ids    = ["${aws_security_group.rds.id}"]

    skip_final_snapshot  = true
    parameter_group_name = aws_db_parameter_group.imbee_group.name
    db_subnet_group_name = aws_db_subnet_group.subnet_group.name
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
