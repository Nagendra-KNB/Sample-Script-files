# variables.tf

variable "aws_profile" {
  description = "AWS profile for credentials"
  type        = string
  default     = "geek"  # Set your AWS CLI profile name here
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instance (Ubuntu)"
  type        = string
  default     = "ami-0dee22c13ea7a9a67"  # Ubuntu Server 24.04 LTS (HVM), SSD Volume Type 
}

variable "instance_type" {
  description = "The instance type"
  type        = string
  default     = "t2.large"  # Adjust as necessary
}

variable "key_pair_name" {
  description = "The name of the existing EC2 key pair"
  type        = string
  default     = "terraform-test"  # The existing key pair name
}

variable "instance_name" {
  description = "The name of the EC2 instance"
  type        = string
  default     = "pixar_instance"  # Instance name tag
}
variable "volume_size" {
  description = "Size of the root EBS volume in GB"
  default     = 40  # 40 GB volume
}

variable "associate_public_ip" {
  description = "Boolean flag to associate a public IP address to the EC2 instance"
  type        = bool
  default     = true
}


variable "user_data" {
  description = "User data script to run on instance launch"
  type        = string
  default     = ""
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.10.0.0/16"
}

variable "subnet1_cidr" {
  description = "CIDR block for subnet1"
  default     = "10.10.1.0/24"
}

variable "subnet2_cidr" {
  description = "CIDR block for subnet2"
  default     = "10.10.2.0/24"
}

variable "subnet3_cidr" {
  description = "CIDR block for subnet3"
  default     = "10.10.3.0/24"
}

variable "ec2_ebs_az" {
  description = "Availability zone for the EBS volume"
  type        = string
  default     = "ap-south-1a"  # Example AZ (adjust as needed)
}
