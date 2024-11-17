resource "aws_security_group" "nodes" {
  name_prefix = "nodes_sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.16.0.0/16"
    ]
  }
}