output "instance_public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.petclinic_app.public_ip
}

output "application_url" {
  description = "Application URL"
  value       = "http://${aws_instance.petclinic_app.public_ip}:8080/petclinic"
}
