terraform {
   backend "s3" {
      key            = "rahul-demo/ec2-instances/test1/terraform.tfstate"
      region         = "us-west-2"
      #dynamodb_table = "terraform_locks"
      encrypt        = "true"
   }
}

data "aws_ami" "app-ami" {
  most_recent      = true

  filter {
    name       = "name"
    values     = ["amzn2-ami-hvm-2.0*"]
  }
  owners       = ["amazon"]
}

data "template_file" "main" {
  template 	= "${file("userdata.yml-template")}"
  vars      = {
  }
}

locals {
  common_tags = "${map(
    "Application", "${var.app}",
    "Owner", "${var.owner}",
    "CreatedBy", "${var.createdBy}>",
    "Environment", "${var.env}"
  )}"
}

resource "tls_private_key" "agent" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "agent" {
  key_name   = "${var.app}-${var.env}_key"
  public_key = "${tls_private_key.agent.public_key_openssh}"
}

resource "aws_instance" "main" {
   ami                         = "${data.aws_ami.app-ami.id}"
   instance_type               = "${var.instance_type}"
   user_data                   = "${data.template_file.main.rendered}"
   subnet_id                   = "${var.internal_vpc_subnet_id}"
   vpc_security_group_ids      = ["${aws_security_group.ec2_instance_sg.id}"]
   associate_public_ip_address = "${var.associate_pub_ip}"
   key_name                    = "${aws_key_pair.agent.key_name}"
   iam_instance_profile        = "${aws_iam_instance_profile.EC2RoleProfile.id}"
   count                       = "${var.server_count}"

   root_block_device {
      volume_type = "gp2"
      volume_size = "${var.volume_size}"
      encrypted   = true
      kms_key_id  = "${var.kms_key_id}"
   }

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "rahul demo"
    )
  )}"

   lifecycle {
     create_before_destroy = false
   }
}
/*
resource "aws_ebs_volume" "create_volume" {
   count        	     = "${var.server_count}"
   availability_zone     = "${var.availability_zone}"
   type                  = "gp2"
   size                  = "${var.volume_size}"
   encrypted             = true
   kms_key_id            = "${var.kms_key_id}"

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "Azure DevOps Agent"
    )
  )}"
}

resource "aws_volume_attachment" "ebs_att" {
   count        = "${var.server_count}"
   device_name  = "/dev/sda1"
   volume_id    = "${element(aws_ebs_volume.create_volume.*.id, count.index)}"
   instance_id  = "${element(aws_instance.main.*.id, count.index)}"
}
*/
