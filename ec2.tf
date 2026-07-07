# ==============================================================================
# ec2.tf
# ==============================================================================
# This file provisions the compute resources for the TerraForge stack.
# It includes:
# 1. A dynamic query (data source) to look up the latest Amazon Linux 2023 AMI.
# 2. A Security Group to control inbound and outbound traffic (acting as a firewall).
# 3. An EC2 instance with an IAM role and Nginx setup.
# ==============================================================================

# Data source to fetch the latest Amazon Linux 2023 AMI.
# This prevents hardcoding the AMI ID, which changes frequently across regions and updates.
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  # Filters are used to search for the specific AMI pattern.
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security Group: Firewall rules governing network traffic.
# For security, we follow the principle of least privilege:
# - Inbound (Ingress): Allow only SSH (22) for remote shell access, and HTTP (80) for web traffic.
# - Outbound (Egress): Allow all outbound traffic so the server can download package updates (Nginx).
resource "aws_security_group" "web_sg" {
  name        = "${var.project_name}-web-sg"
  description = "Security group for web server allowing SSH and HTTP traffic"

  # SSH access rule
  ingress {
    description = "SSH access from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access rule
  ingress {
    description = "HTTP access from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule (all outbound traffic allowed)
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-web-sg"
    Project = var.project_name
  }
}

# EC2 Instance: The virtual machine running our web server.
resource "aws_instance" "web" {
  # Dynamically pull the latest AMI ID fetched by the data source above.
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type

  # Associate our security group with the instance.
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # Attach the IAM Instance Profile containing S3 access credentials.
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  # User Data script: runs automatically on first boot as root.
  # Installs, configures, and starts Nginx.
  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y nginx
              systemctl start nginx
              systemctl enable nginx
              echo "<h1>TerraForge — deployed via Terraform</h1>" > /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name    = "${var.project_name}-web-instance"
    Project = var.project_name
  }
}
