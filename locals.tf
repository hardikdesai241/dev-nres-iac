locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "hardik.desai@naturalretreats.com"
    Owner       = "Parkar-Infrastructure-Team"
    CreatedBy   = "hardik.desai@naturalretreats.com"
    CreatedOn   = timestamp()
  }
}