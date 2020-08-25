provider "aws" {
  version = "<= 2.63"
  region  = "${var.aws_region}"
}

terraform {
  required_version = "<= 0.11.15"
}