output "aws_ec2_ips" {
  description = "IP of EC2 Instance"
  value       = ["${aws_instance.dev_node.public_ip}"]
}