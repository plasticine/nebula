resource "aws_route53_zone" "main" {
  name = "sploosh.cool"
  vpc_id = "${aws_vpc.default.id}"
}
