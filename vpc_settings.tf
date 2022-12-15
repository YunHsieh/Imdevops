# Create a VPC
resource "aws_vpc" "myvpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support   = true
}


resource "aws_internet_gateway" "internet" {
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


resource "aws_db_subnet_group" "subnet_group" {
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

resource "aws_route_table" "rds_route" {
    vpc_id = aws_vpc.myvpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet.id
    }

    tags = {
        Name = "RDS mysql internet"
    }
}

resource "aws_main_route_table_association" "route_main" {
    vpc_id         = aws_vpc.myvpc.id
    route_table_id = aws_route_table.rds_route.id
}
