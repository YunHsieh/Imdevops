variable "region" {
    description = "aws region"
    type        = string
    default = "ap-northeast-1"
}

variable "db_username" {
    description = "when create db, set the username"
    type        = string
}

variable "db_password" {
    description = "when create db, set the password"
    type        = string
}

variable "db_name" {
    description = "when create db, set the db"
    type        = string
}

variable "stage" {
    description = "when create db, set the password"
    type        = string
}

variable "project_name" {
    description = "when create db, set the password"
    type        = string
    default     = "imbee"
}
