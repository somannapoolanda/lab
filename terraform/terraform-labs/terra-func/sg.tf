# TOPICS: Dynamic Blocks, List
# Description: Security group with dynamic ingress rules using LIST and DYNAMIC block
resource "aws_security_group" "allow_all" {
  name        = "${var.vpc_name}-allow-all"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.default.id

  # DYNAMIC BLOCK: Creates multiple ingress rules from LIST (var.ingress_ports)
  dynamic "ingress" {
    for_each = var.ingress_ports  # LIST: iterates over port numbers
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
