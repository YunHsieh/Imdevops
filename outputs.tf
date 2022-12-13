output "rds_endpoint" {
    value = "${aws_db_instance.default.endpoint}"
}

output "ecr_url" {
    value = "${aws_ecr_repository.repo_imbee.repository_url}"
}
