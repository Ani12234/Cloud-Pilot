# ==============================================================================
# s3.tf
# ==============================================================================
# This file provisions a secure, private S3 bucket.
# It includes:
# 1. A random ID suffix to guarantee a globally unique bucket name.
# 2. The S3 bucket resource itself.
# 3. Enablement of object versioning for rollback capabilities.
# 4. A public access block to enforce absolute privacy of our bucket contents.
# ==============================================================================

# Generates a random 6-byte hexadecimal string.
# This prevents S3 bucket name conflicts, which are global in AWS.
resource "random_id" "bucket_suffix" {
  byte_length = 6
}

# The main S3 Bucket resource.
resource "aws_s3_bucket" "bucket" {
  # Concatenate the prefix and the random hexadecimal suffix.
  bucket = "${var.bucket_name}-${random_id.bucket_suffix.hex}"

  # force_destroy allows Terraform to delete the bucket and its contents during
  # "terraform destroy". Set to false in production to prevent accidental data loss.
  force_destroy = true

  tags = {
    Name    = "${var.project_name}-s3-bucket"
    Project = var.project_name
  }
}

# Enable versioning on the S3 bucket.
# Versioning keeps multiple variants of an object, allowing recovery of overwritten or deleted files.
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enforce secure access controls on the S3 bucket.
# Blocks all public ACLs and Policies to prevent accidental data leaks to the internet.
resource "aws_s3_bucket_public_access_block" "bucket_public_block" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
