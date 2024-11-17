resource "aws_ecr_repository" "ecr_repos" {
  for_each = toset(var.ecr_repos)
  name    = each.value

  #Ideal security best practice should be IMMUTABLE
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "frontend_ecr" {
  value = aws_ecr_repository.ecr_repos["frontend"].repository_url
}

output "backend_ecr" {
  value = aws_ecr_repository.ecr_repos["backend"].repository_url
}
