# ==============================================================================
# variables.tf
# ==============================================================================
# This file declares input parameters for the Terraform configuration.
# Declaring variables enables modularity, reusability, and parameterization,
# preventing hardcoded values in resource definitions.
# ==============================================================================

variable "aws_region" {
  type        = string
  description = "The target AWS Region for resource deployment."
  default     = "ap-south-1" # Default region is ap-south-1 (Mumbai)
}

variable "instance_type" {
  type        = string
  description = "The EC2 instance type. t2.micro is Free-Tier eligible in most regions."
  default     = "t2.micro"
}

variable "bucket_name" {
  type        = string
  description = "The prefix or base name of the S3 bucket. A random suffix will be added to ensure global uniqueness."
  default     = "terraforge-bucket"
}

variable "project_name" {
  type        = string
  description = "A standard name tag used to identify resources associated with this project."
  default     = "TerraForge"
}
