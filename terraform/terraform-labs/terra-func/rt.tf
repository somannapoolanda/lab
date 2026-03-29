# TOPICS: Count, Index
# Description: Associates public subnets with route table using count and index
resource "aws_route_table_association" "public-subnets" {
  count          = length(aws_subnet.public-subnet.*.id)  # COUNT: creates association for each subnet
  subnet_id      = aws_subnet.public-subnet[count.index].id  # INDEX: references specific subnet instance
  route_table_id = aws_route_table.public-route-table.id
}

# TOPICS: Count, Index
# Description: Associates private subnets with route table using count and index
resource "aws_route_table_association" "private-subnets" {
  count          = length(aws_subnet.private-subnet.*.id)  # COUNT: creates association for each subnet
  subnet_id      = aws_subnet.private-subnet[count.index].id  # INDEX: references specific subnet instance
  route_table_id = aws_route_table.private-route-table.id
}
