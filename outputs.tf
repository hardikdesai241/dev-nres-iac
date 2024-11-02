output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "nlb_dns_name" {
  description = "DNS name of the Network Load Balancer"
  value       = aws_lb.main.dns_name
}

output "instance_ids_1a" {
  description = "IDs of instances in AZ1a"
  value       = aws_instance.ec2_1a[*].id
}

output "instance_ids_1b" {
  description = "IDs of instances in AZ1b"
  value       = aws_instance.ec2_1b[*].id
}

output "public_ips_1a" {
  description = "Public IPs of instances in AZ1a"
  value       = aws_instance.ec2_1a[*].public_ip
}

output "public_ips_1b" {
  description = "Public IPs of instances in AZ1b"
  value       = aws_instance.ec2_1b[*].public_ip
}

output "subnet_1a_id" {
  description = "ID of the subnet in AZ1a"
  value       = aws_subnet.subnet_1a.id

}

output "subnet_1b_id" {
  description = "ID of the subnet in AZ1b"
  value       = aws_subnet.subnet_1b.id
}

output "dev-oraclerds-subnet_1a_id" {
  description = "ID of the RDS subnet in AZ1a"
  value       = aws_subnet.dev-oraclerds-subnet_1a.id

}

output "dev-oraclerds-subnet_1b_id" {
  description = "ID of the RDS subnet in AZ1b"
  value       = aws_subnet.dev-oraclerds-subnet_1b.id

}

output "dev-oraclerds-SG_id" {
  description = "ID of the RDS security group"
  value       = aws_security_group.dev-oraclerds-SG.id

}

output "dev-oraclerds_id" {
  description = "ID of the RDS instance"
  value       = aws_db_instance.dev-oraclerds.id
}


output "dev-oraclerds_endpoint" {
  description = "The connection endpoint"
  value       = aws_db_instance.dev-oraclerds.endpoint
}

output "de-oraclerds_port" {
  description = "The database port"
  value       = aws_db_instance.dev-oraclerds.port
}