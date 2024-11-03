variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_1a_cidr" {
  description = "CIDR block for Listner subnet in AZ 1a"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_1b_cidr" {
  description = "CIDR block for Listner subnet in AZ 1b"
  type        = string
  default     = "10.0.2.0/24"
}

variable "dev-oraclerds-subnet_1a_cidr" {
  description = "CIDR block for RDS subnet in AZ 1a"
  type        = string
  default     = "10.0.3.0/24"
}

variable "dev-oraclerds-subnet_1b_cidr" {
  description = "CIDR block for RDS subnet in AZ 1b"
  type        = string
  default     = "10.0.4.0/24"
}


variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-0261755bbcb8c4a84" # Amazon Linux 2 AMI
}

variable "instances_per_subnet" {
  description = "Number of EC2 instances per subnet"
  type        = number
  default     = 2
}

variable "admin_ip_cidr" {
  description = "CIDR block for admin access"
  type        = string
  default     = "0.0.0.0/0" # Change this to your IP for better security
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "dev-nres-neworacle"
}

variable "dev-nres-key-pair" {
  description = "key pair to use for EC2 instance access"
  type        = string
  default     = "dev-nres-key-pair"
}

variable "db_username" {
  description = "Username for the RDS Oracle database"
  type        = string
  default     = "admin" # or anything as needed
}

variable "db_password" {
  description = "Password for the RDS Oracle database"
  type        = string
  sensitive   = true # Marks this as sensitive for security purposes
}

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}
 