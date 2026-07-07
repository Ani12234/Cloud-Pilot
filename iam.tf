# ==============================================================================
# iam.tf
# ==============================================================================
# This file manages identity and access configurations.
# It configures:
# 1. An IAM Role that EC2 instances can assume.
# 2. A custom IAM Policy enforcing least-privilege access restricted to our bucket.
# 3. A policy attachment to link the policy to our role.
# 4. An Instance Profile wrapper to associate the role with the EC2 virtual machine.
# ==============================================================================

# IAM Role: A secure container for permissions.
# It defines an trust policy allowing EC2 service to assume this role.
resource "aws_iam_role" "ec2_s3_role" {
  name = "${var.project_name}-ec2-s3-role"

  # The trust policy allowing EC2 instances to assume this role.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Project = var.project_name
  }
}

# Least-Privilege IAM Policy.
# Restricts access *exclusively* to the S3 bucket created in s3.tf.
# - ListBucket is applied to the bucket itself (arn:aws:s3:::bucket-name).
# - GetObject, PutObject, DeleteObject are applied to the bucket contents (arn:aws:s3:::bucket-name/*).
resource "aws_iam_policy" "s3_access_policy" {
  name        = "${var.project_name}-s3-access-policy"
  description = "Provides least-privilege read and write permissions to the TerraForge S3 bucket."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.bucket.arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "${aws_s3_bucket.bucket.arn}/*"
        ]
      }
    ]
  })
}

# Attach the policy directly to the IAM Role.
resource "aws_iam_role_policy_attachment" "s3_policy_attachment" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

# IAM Instance Profile.
# AWS EC2 requires an instance profile to associate an IAM role with an EC2 resource.
# This profile acts as the bridge.
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.ec2_s3_role.name
}
