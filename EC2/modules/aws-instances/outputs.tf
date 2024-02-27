output "aws_ec2_ips" {
  description = "IP of EC2 Instance"
  value       = ["${aws_instance.dev_node.public_ip}"]
}

#output "aws_ec2_tags" {
#    description = "EC2 Tags"
#    value = "${aws_instance.dev_node.tags.Name}"
#}