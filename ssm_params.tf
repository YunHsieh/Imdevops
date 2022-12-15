resource "aws_ssm_parameter" "notification_ecr" {
    name  = "/imbee/infra/notification-ecr"
    type  = "String"
    value = aws_ecr_repository.repo_imbee.repository_url

    tags = {
        name = "imbee"
    }
}


resource "aws_ssm_parameter" "database_url" {
    name  = "/imbee/infra/database-url"
    type  = "String"
    value = aws_db_instance.imbee_db.endpoint

    tags = {
        name = "imbee"
    }
}


resource "aws_ssm_parameter" "database_username" {
    name  = "/imbee/infra/database-username"
    type  = "String"
    value = aws_db_instance.imbee_db.username

    tags = {
        name = "imbee"
    }
}


resource "aws_ssm_parameter" "database_password" {
    name  = "/imbee/infra/database-password"
    type  = "SecureString"
    value = "imbeepw1"

    tags = {
        name = "imbee"
    }
}


resource "aws_ssm_parameter" "database_name" {
    name  = "/imbee/infra/database-name"
    type  = "String"
    value = aws_db_instance.imbee_db.db_name

    tags = {
        name = "imbee"
    }
}


resource "aws_ssm_parameter" "subnet_1" {
    name  = "/imbee/infra/subnet-1"
    type  = "String"
    value = aws_subnet.ap-northeast-1a.id

    tags = {
        name = "imbee"
    }
}


resource "aws_ssm_parameter" "subnet_2" {
    name  = "/imbee/infra/subnet-2"
    type  = "String"
    value = aws_subnet.ap-northeast-1c.id

    tags = {
        name = "imbee"
    }
}


resource "aws_ssm_parameter" "subnet_3" {
    name  = "/imbee/infra/subnet-3"
    type  = "String"
    value = aws_subnet.ap-northeast-1d.id

    tags = {
        name = "imbee"
    }
}


resource "aws_ssm_parameter" "security_group" {
    name  = "/imbee/infra/security_group_id"
    type  = "String"
    value = aws_security_group.rds.id

    tags = {
        name = "imbee"
    }
}
