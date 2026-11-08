output "instance_name" {
  description = "Name of the EC2 instance created for this lesson."
  value       = local.demo_name
}

output "instance_id" {
  description = "ID of the EC2 instance created for this lesson."
  value       = module.ec2.instance_id
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance."
  value       = module.ec2.instance_private_ip
}