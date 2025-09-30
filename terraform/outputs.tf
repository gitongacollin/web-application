output "instance_public_ip" {
  value       = aws_eip.webapp.public_ip                    # The actual value to be outputted
  description = "The public IP address of the EC2 instance" # Description of what this output represents
}

output "instance_id" {
  value       = aws_instance.webapp.id
  description = "The ID of the EC2 Instance"
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "url" {
  value = "http://${aws_eip.webapp.public_ip}"
}