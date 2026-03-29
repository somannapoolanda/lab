# TOPICS: Count, Index, Element, List
# Description: Creates multiple public subnets using count to iterate over lists
resource "aws_subnet" "public-subnet" {
  count             = length(var.public_cidr_block)  # COUNT: determines how many subnets to create
  vpc_id            = aws_vpc.default.id
  cidr_block        = element(var.public_cidr_block, count.index)  # ELEMENT & INDEX: retrieves value from LIST at specific position
  availability_zone = element(var.azs, count.index)  # ELEMENT & INDEX: retrieves AZ from LIST at specific position

  tags = {
    Name        = "${var.vpc_name}-public-subnet-${count.index + 1}"
    Owner       = "${local.owner}"
    costcenter  = "${local.costcenter}"
    Teamdl      = "${local.Teamdl}"
    environment = "${var.environment}"
  }
}


# TOPICS: Count, Index, Element, List
# Description: Creates multiple private subnets using count to iterate over lists
resource "aws_subnet" "private-subnet" {
  count             = length(var.private_cidr_block)  # COUNT: determines how many subnets to create
  vpc_id            = aws_vpc.default.id
  cidr_block        = element(var.private_cidr_block, count.index)  # ELEMENT & INDEX: retrieves value from LIST at specific position
  availability_zone = element(var.azs, count.index)  # ELEMENT & INDEX: retrieves AZ from LIST at specific position

  tags = {
    Name        = "${var.vpc_name}-private-subnet-${count.index + 1}"
    Owner       = "${local.owner}"
    costcenter  = "${local.costcenter}"
    Teamdl      = "${local.Teamdl}"
    environment = "${var.environment}"
  }
}
