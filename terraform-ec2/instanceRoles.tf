# Determine the current caller identity to extract the account id
data "aws_caller_identity" "current" {}

# The role that the application instance-profile attaches to.
resource "aws_iam_role" "ec2-role"  {
   name = "${var.app}-${var.env}role"
   assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ec2" {
    name = "${var.app}-role-policy"
    role = "${aws_iam_role.ec2-role.name}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "cloudwatch:*",
                "logs:*",
                "ssm:*",
                "ec2:*",
                "ecr:*",
                "cloudformation:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "EC2RoleProfile" {
    name = "${var.app}-${var.env}-EC2RoleProfile"
    role = "${aws_iam_role.ec2-role.name}"
}


