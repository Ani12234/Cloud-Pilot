# ==============================================================================
# outputs.tf
# ==============================================================================
# Outputs expose internal resource properties back to the terminal or command line
# after applying changes. This acts as a feedback mechanism for users or scripts.
# ==============================================================================

output "ec2_public_ip" {
  value       = aws_instance.web.public_ip
  description = "The public IP address of the provisioned EC2 instance."
}

output "site_url" {
  value       = "http://${aws_instance.web.public_ip}"
  description = "The ready-to-click site URL hosting the custom Kubernetes application."
}

output "grafana_url" {
  value       = "http://${aws_instance.web.public_ip}:3000"
  description = "The Grafana dashboard connection URL."
}

output "ssh_command" {
  value       = "ssh -i terraforge-key-pem ec2-user@${aws_instance.web.public_ip}"
  description = "The SSH connection string for administrative cluster access."
}

output "s3_bucket_name" {
  value       = aws_s3_bucket.bucket.id
  description = "The actual globally unique name of the created S3 bucket."
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.bucket.arn
  description = "The Amazon Resource Name (ARN) of the created S3 bucket."
}

output "iam_role_arn" {
  value       = aws_iam_role.ec2_s3_role.arn
  description = "The ARN of the IAM Role attached to the EC2 instance profile."
}
