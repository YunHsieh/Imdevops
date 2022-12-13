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
}


resource "aws_subnet" "ap-northeast-1a" {
    vpc_id            = aws_vpc.myvpc.id
    availability_zone = "ap-northeast-1a"
    cidr_block        = "10.0.1.0/24"

    tags = {
        AZ = "1a"
    }
}


resource "aws_subnet" "ap-northeast-1c" {
    vpc_id            = aws_vpc.myvpc.id
    availability_zone = "ap-northeast-1c"
    cidr_block        = "10.0.2.0/24"

    tags = {
        AZ = "1c"
    }
}


resource "aws_subnet" "ap-northeast-1d" {
    vpc_id            = aws_vpc.myvpc.id
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

# resource

# module "functions" {
#   source = "./modules/functions"
# }



resource "aws_sqs_queue" "terraform_queue" {
    name                      = "notification-queue-fcm.fifo"
    fifo_queue                  = true
    content_based_deduplication = true
    delay_seconds             = 90
    max_message_size          = 2048
    message_retention_seconds = 86400
    receive_wait_time_seconds = 10
    deduplication_scope       = "messageGroup"
    fifo_throughput_limit     = "perMessageGroupId"
    redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.terraform_queue_dlq.arn
    maxReceiveCount     = 4
})

    tags = {
        Environment = var.stage
    }
}


resource "aws_sqs_queue" "terraform_queue_dlq" {
    name                        = "notification-queue-fcm-dlq.fifo"
    fifo_queue                  = true
}


resource "aws_db_instance" "default" {
    allocated_storage    = 10
    max_allocated_storage = 20
    db_name              = var.db_name
    engine               = "mysql"
    engine_version       = "5.7.40"
    instance_class       = "db.t3.micro"
    username             = var.db_username
    password             = var.db_password
    parameter_group_name = "default.mysql5.7"
    skip_final_snapshot  = true
    db_subnet_group_name = aws_db_subnet_group.subnetGroup.name
}

resource "aws_ecr_repository" "repo_imbee" {
    name                 = var.project_name
    image_tag_mutability = "MUTABLE"

    image_scanning_configuration {
        scan_on_push = true
    }
}
