# ==============================================================================
# main.tf
# ==============================================================================
# This file sets up the provider requirements and global settings.
# It defines which versions of Terraform and providers we are using,
# ensuring predictability and stability across different environments.
# ==============================================================================

terraform {
  # Specifies that this configuration requires at least Terraform version 1.0.0.
  required_version = ">= 1.0.0"

  # Declares the required provider plugins and versions.
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Allows minor updates within AWS v5.x but prevents breaking v6.x upgrades
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0" # Used to generate random suffixes for global resource uniqueness (e.g., S3)
    }
  }
}

# The AWS Provider block configures access to AWS resources.
# The actual credentials will be picked up automatically from the local environment
# (like your AWS CLI profiles, environment variables, or IAM role credentials).
# Using variables here ensures we don't hardcode sensitive or region-specific values.
provider "aws" {
  region = var.aws_region
}
