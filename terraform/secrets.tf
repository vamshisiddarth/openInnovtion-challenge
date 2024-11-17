resource "aws_secretsmanager_secret" "frontend" {
  name = "frontend"
}

resource "aws_secretsmanager_secret_version" "frontend" {
  secret_id = aws_secretsmanager_secret.frontend.id
  secret_string = aws_ecr_repository.ecr_repos["frontend"].repository_url

  depends_on = [
    aws_ecr_repository.ecr_repos
  ]
}

resource "aws_secretsmanager_secret" "backend" {
  name = "backend"
}

resource "aws_secretsmanager_secret_version" "backend" {
  secret_id = aws_secretsmanager_secret.backend.id
  secret_string = aws_ecr_repository.ecr_repos["backend"].repository_url

  depends_on = [
    aws_ecr_repository.ecr_repos
  ]
}

resource "aws_secretsmanager_secret" "postgress_credentials" {
  name = "postgres_credentials"
}

resource "aws_secretsmanager_secret_version" "postgress_credentials" {
  secret_id = aws_secretsmanager_secret.postgress_credentials.id
  secret_string = random_password.postgres_password.result

  depends_on = [
    aws_ecr_repository.ecr_repos
  ]
}