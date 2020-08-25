output "private_key" {
  value = "${tls_private_key.agent.private_key_pem}"
}

output "ip_address" {
  value = "${aws_instance.main.*.private_ip}"
}

output "account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
}
