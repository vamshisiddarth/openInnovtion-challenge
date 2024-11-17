variable "region" {
  default     = "eu-west-1"
  description = "AWS region"
}

variable "name" {
  default = "challenge"
}

variable "ecr_repos" {
  default = ["frontend", "backend"]
}