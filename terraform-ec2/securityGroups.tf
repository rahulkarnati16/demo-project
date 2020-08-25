variable "ec2_sg_rules" {
  type        = "map"
  description = "(Optional) A Map used to create all required security group rules"
  default     = {
  "0" = "egress,0,0,-1,0.0.0.0/0"
  "1" = "ingress,22,22,tcp,10.0.0.0/8"
  "2" = "ingress,3306,3306,tcp,10.0.0.0/8"
  }
}

resource "aws_security_group" "ec2_instance_sg" {
  name_prefix   =  "${var.app}-${var.env}-sg"
  description   = "Allow webapp and db ingress open egress"
  vpc_id        = "${var.internal_vpc_id}"

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "rahul Demo SG"
    )
  )}"
}

resource "aws_security_group_rule" "ec2_instance" {
  count = "${length(var.ec2_sg_rules)}"

  type            = "${element(split(",", lookup(var.ec2_sg_rules, count.index)), 0) }"
  from_port       = "${element(split(",", lookup(var.ec2_sg_rules, count.index)), 1) }"
  to_port         = "${element(split(",", lookup(var.ec2_sg_rules, count.index)), 2) }"
  protocol        = "${element(split(",", lookup(var.ec2_sg_rules, count.index)), 3) }"
  cidr_blocks     = ["${element(split(",", lookup(var.ec2_sg_rules, count.index)), 4) }"]

  security_group_id = "${aws_security_group.ec2_instance_sg.id}"
}
