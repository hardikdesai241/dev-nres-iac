locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "hardik[dot]desai[at]naturalretreats[dot]com"
    Owner       = "Parkar-Infrastructure-Team"
    CreatedBy   = "hardik[dot]desai[at]naturalretreats[dot]com"
    CreatedOn   = "Nov 2024"
  }
}