resource "aws_db_instance" "postgres" {
  identifier              = "challenge-db"
  engine                  = "postgres"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_name                 = "challenge"
  username                = "dbuser"
  password                = random_password.postgres_password.result
  publicly_accessible     = false
  vpc_security_group_ids  = [module.vpc.default_security_group_id]
  db_subnet_group_name    = module.vpc.database_subnet_group_name

  skip_final_snapshot     = true
}

resource "random_password" "postgres_password" {
  length = 10
  special = false
}

resource "aws_security_group" "eks_to_postgres" {
  name        = "eks-postgres-access"
  description = "Allow EKS nodes to access PostgreSQL DB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [
      module.vpc.private_subnets_cidr_blocks,
      module.vpc.public_subnets_cidr_blocks
    ]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "-1"
    cidr_blocks = [
      module.vpc.private_subnets_cidr_blocks,
      module.vpc.public_subnets_cidr_blocks
    ]
  }
}