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

  # Grafana access rule
  ingress {
    description = "Grafana access from anywhere"
    from_port   = 3000
    to_port     = 3000
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

# SSH Key Pair associated with the EC2 instance.
resource "aws_key_pair" "deployer" {
  key_name   = "${var.project_name}-deployer-key"
  public_key = file("${path.module}/terraforge-key.pub")
}

# EC2 Instance: The virtual machine running our web server and Kubernetes cluster.
resource "aws_instance" "web" {
  # Dynamically pull the latest AMI ID fetched by the data source above.
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type

  # Associate our security group with the instance.
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # Attach the IAM Instance Profile containing S3 access credentials.
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  # Attach the SSH key pair for deployment and admin access.
  key_name = aws_key_pair.deployer.key_name

  # User Data script: runs automatically on first boot as root.
  # Sets up a swap file, installs K3s, and prepares the node.
  user_data = <<-EOF
              #!/bin/bash
              # Allocate 2GB of swap space to prevent memory issues
              fallocate -l 2G /swapfile
              chmod 600 /swapfile
              mkswap /swapfile
              swapon /swapfile
              echo "/swapfile none swap sw 0 0" >> /etc/fstab

              # Update system packages
              dnf update -y

              # Bootstrap K3s without Traefik (we use Klipper Host port mapping)
              curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--write-kubeconfig-mode 644 --disable traefik --disable local-storage" sh -s -
              EOF

  tags = {
    Name    = "${var.project_name}-web-instance"
    Project = var.project_name
  }
}
